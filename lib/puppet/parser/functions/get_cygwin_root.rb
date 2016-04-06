require 'open3'

BLOCK_SIZE = 1024

def all_eof(files)
  files.find { |f| !f.eof }.nil?
end

module Puppet::Parser::Functions
  newfunction(:get_cygwin_root, :type => :rvalue) do |args|
    reg_cmd = (ENV['systemroot'].split('\\') << 'System32' << 'reg.exe').join('/')
    
    command = reg_cmd + " query HKLM\\Software\\Cygwin\\setup"
    
    #puts "Running command: #{command}"
    
    
    found = false
    cygrootdir = ''
    
    Open3.popen3(command) do |stdin, stdout, stderr|
      stdin.close_write
    
      begin
        files = [stdout, stderr]
    
        until all_eof(files) do
          ready = IO.select(files)
    
          if ready
            readable = ready[0]
            # writable = ready[1]
            # exceptions = ready[2]
    
            readable.each do |f|
              fileno = f.fileno
    
              begin
                #data = f.read_nonblock(BLOCK_SIZE)
                data = f.read
    
                # Do something with the data...
                #puts "fileno: #{fileno}, data: #{data}"
                sdata = data.split(/ +/)
                sz = sdata.size
                if sz > 1 and sdata[1] == "rootdir" and sdata[3]
                  cygrootdir = sdata[3].chomp.chomp
                  #if File.exist?(cygrootdir)
                    #puts "Found #{cygrootdir}"
                    found = true
                  #end
                end
              rescue EOFError => e
                #puts "fileno: #{fileno} EOF"
                #some = fileno
              end
            end
          end
        end
      rescue IOError => e
        #puts "IOError: #{e}"
      end
    end
    
    #puts "Done, found: #{found}"
    if found
      #puts "cygrootdir: #{cygrootdir}"
      return cygrootdir
    end
  end
end

# == Class: librarian_puppet
#
# Setup and configure librarian-puppet as puppet's embedded ruby and gem
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { 'librarian_puppet':
#  }
#
# === Authors
#
# st01tkh <st01tkh@gmail.com>
#
# === Copyright
#
# Copyright 2016 st01tkh
#
class librarian_puppet {
  $sysdrv = env("SYSTEMDRIVE")
  notify {"system drive: ${sysdrv}": }
  $sysroot = env("SYSTEMROOT")
  $sys32 = file_join_win(["${sysroot}", "System32"])
      
  $pl_basedir = file_join_win(["${sysdrv}", "Program Files", "Puppet Labs", "Puppet"])
  $pl_base_bin_dir = file_join_win(["${pl_basedir}", "bin"])
  $pl_sys_dir = file_join_win(["${pl_basedir}", "sys"])
  $pl_ruby_dir = file_join_win(["${pl_sys_dir}", "ruby"])
  $pl_ruby_bin_dir = file_join_win(["${pl_ruby_dir}", "bin"])
  notify {"puppet ruby bin dir: $pl_ruby_bin_dir": }
  $puppet_bin = file_join_win(["${pl_base_bin_dir}", "puppet.bat"])
  $puppet_bin_dir = file_join_win(["${pl_basedir}", "puppet", "bin"])
  $facter_bin_dir = file_join_win(["${pl_basedir}", "facter", "bin"])
  $hiera_bin_dir = file_join_win(["${pl_basedir}", "hiera", "bin"])

  #exec {"some commadn":
  #    path => ["$sysroot", "$sys32", "${pl_base_bin_dir}", "${puppet_bin_dir}"],
  #} ->
  windows_path {"add puppet's embedded ruby bin dir to PATH":
    ensure      => present,
    directory   => "$pl_ruby_bin_dir",
  }
}

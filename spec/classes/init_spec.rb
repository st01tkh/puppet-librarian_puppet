require 'spec_helper'
describe 'librarian_puppet' do

  context 'with defaults for all parameters' do
    it { should contain_class('librarian_puppet') }
  end
end

require 'spec_helper'

describe 'Appropriate permissions using file globbing' do
  describe file('/tmp/foo/specifications/bar.gemspec') do
    it { should be_file }
    it { should exist }
    it { should be_mode 644 }
  end
end

describe 'Appropriate permissions using file and dir globbing' do
  describe file('/tmp/foo/bin/bar.rb') do
    it { should be_file }
    it { should exist }
    it { should be_mode 644 }
  end
end

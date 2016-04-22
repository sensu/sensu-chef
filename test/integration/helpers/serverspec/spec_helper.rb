require "net/http"
require 'serverspec'
require "uri"

# h/t to @martinb3 for http://martinb3.io/testkitchen-serverspec-windows/
if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
  set :path, "/bin:/usr/bin:/sbin:/usr/sbin:$PATH"
else
  set :backend, :cmd
  set :os, :family => "windows"
end

puts "os: #{os}"

# helper methods to conditionally guard individual tests by platform
def linux?
  %w(debian redhat ubuntu).include?(os[:family])
end

def windows?
  %w(windows).include?(os[:family])
end

def sensu_directory
  case windows?
  when true
    'C:\etc\sensu'
  else
    "/etc/sensu"
  end
end

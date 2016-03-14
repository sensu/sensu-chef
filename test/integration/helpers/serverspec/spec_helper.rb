require "net/http"
require 'serverspec'
require "uri"

set :backend, :exec
set :path, "/bin:/usr/bin:/sbin:/usr/sbin"

puts "os: #{os}"

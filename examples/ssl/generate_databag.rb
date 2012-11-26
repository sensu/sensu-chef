#!/usr/bin/env ruby

require 'rubygems'
require 'json'

def process_pem(filename)
  output = ""
  File.open(filename).each_line do |line|
    output << line
  end
  output
end

content = {
  :id => "ssl",
  :server => {
    :key => process_pem("server/key.pem"),
    :cert => process_pem("server/cert.pem"),
    :cacert => process_pem("sensu_ca/cacert.pem")
  },
  :client => {
    :key => process_pem("client/key.pem"),
    :cert => process_pem("client/cert.pem")
  }
}

File.open("ssl.json","w") do |data_bag_item|
  data_bag_item.puts JSON.pretty_generate(content)
end

puts "Data bag item created: ssl.json"

foo = { :lol => "wtfbbq" }

sensu_json_file '/etc/sensu/foo.json' do
  content foo
end

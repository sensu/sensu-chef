default.sensu.proxy.port = 80
# keep empty because of deep merge, has to be set in role/environment/node
default.sensu.proxy.server_names = []
default.sensu.proxy.ssl = false
default.sensu.proxy.ssl_port = 443

# it'd be nice to get this automatically but between ruby version, package/gem install and version it's complicated
# has to be set in role/environment/node
default.sensu.proxy.root = nil

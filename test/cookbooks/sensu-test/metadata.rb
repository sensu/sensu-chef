name             "sensu-test"
maintainer       "Sonian, Inc."
maintainer_email "chefs@sonian.net"
license          "Apache 2.0"
description      'Installs sensu stack for cookbook testing'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends          'logrotate'
depends          'sensu'
depends          'chef-vault'
depends          'build-essential'

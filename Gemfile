# This gemfile provides additional gems for testing and releasing this cookbook
# It is meant to be installed on top of ChefDK which provides the majority
# of the necessary gems for testing this cookbook
#
# Run 'chef exec bundle install' to install these dependencies

source "https://rubygems.org"

group :develop do
  gem 'berkshelf', '~> 6.3'
  gem 'chefspec'
  gem 'guard'
  gem 'guard-foodcritic'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'kitchen-docker', '~> 2.6'
  gem 'kitchen-dokken'
  gem 'kitchen-inspec'
  gem 'kitchen-localhost', '~> 0.3'
  gem 'kitchen-vagrant', '~> 1.2'
  gem 'serverspec', '~> 2.36.1'
  gem 'stove', '~> 5.0'
  gem 'test-kitchen', '~> 1.16'
  gem 'winrm'
  gem 'winrm-fs'
  gem 'winrm-elevated'
end

source "https://rubygems.org"

group :lint do
  gem 'foodcritic', '~> 6.0'
  gem 'rubocop', '~> 0.39.0'
end

group :develop do
  gem "chef", "~> 12.9"
  gem "chefspec", "~> 4.5"
  gem "emeril", "~> 0.8"
  gem "librarian-chef"
  gem "rake"
  gem "guard"
  gem "guard-foodcritic"
  gem "guard-rspec"
  gem "guard-rubocop"
end

group :integration do
  gem "chef-zero-scheduled-task", "~> 0.1"
  gem "test-kitchen", "~> 1.7"
  gem "kitchen-docker"
  gem "kitchen-vagrant"
  gem "winrm-fs"
  gem "winrm-transport"
end

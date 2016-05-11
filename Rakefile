#!/usr/bin/env rake

# emeril helps us release the cookbook
require 'emeril/rake_tasks'

task default: [:spec]

Emeril::RakeTasks.new do |t|
  # disable git tag prefix string
  t.config[:tag_prefix] = false
end

# rspec runs unit tests
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = [ 'test/unit/**{,/*/**}/*_spec.rb' ]
  end
rescue LoadError
end

# test-kitchen runs integration tests
begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end

#!/usr/bin/env rake

task default: [:spec]

# stove helps us ship the cookbook
begin
  require 'stove/rake_task'
  Stove::RakeTask.new
rescue LoadError
  puts '>>>>> Stove gem not loaded, omitting tasks' unless ENV['CI']
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

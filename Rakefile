#!/usr/bin/env rake

# emeril helps us release the cookbook
require 'emeril/rake_tasks'

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

# for now we're blacklisting windows platforms in test-kitchen rake tasks
# but keeping them in .kitchen.yml so we can still run as needed via `kitchen` command
%w(
  default-windows-2012-r2
  asset-windows-2012-r2
).each do |suite|
  if Rake::Task.task_defined?("kitchen:#{suite}")

    filtered_tasks = Rake::Task['kitchen:all'].prerequisite_tasks.reject {
      |t| t.name == "kitchen:#{suite}"
    }

    Rake::Task['kitchen:all'].clear
    Rake::Task['kitchen:all'].enhance(filtered_tasks)
    Rake.application.instance_variable_get('@tasks').delete("kitchen:#{suite}")
  end
end

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# guard 'kitchen' do
#   watch(%r{test/.+})
#   watch(%r{^recipes/(.+)\.rb$})
#   watch(%r{^attributes/(.+)\.rb$})
#   watch(%r{^files/(.+)})
#   watch(%r{^templates/(.+)})
#   watch(%r{^providers/(.+)\.rb})
#   watch(%r{^resources/(.+)\.rb})
# end

# rubocop:disable all

guard 'foodcritic', :cookbook_paths => '.', :all_on_start => false do
  watch(%r{attributes/.+\.rb$})
  watch(%r{providers/.+\.rb$})
  watch(%r{recipes/.+\.rb$})
  watch(%r{resources/.+\.rb$})
  watch('metadata.rb')
end

guard 'rubocop', :all_on_start => false do
  watch(%r{attributes/.+\.rb$})
  watch(%r{providers/.+\.rb$})
  watch(%r{recipes/.+\.rb$})
  watch(%r{resources/.+\.rb$})
  watch('metadata.rb')
end

guard :rspec, :cmd => 'bundle exec rspec', :all_on_start => false, :notification => false, :spec_paths => [ 'test/unit' ] do
  watch(%r{^libraries/(.+)\.rb$})   { |m| "test/unit/libraries/#{m[1]}_spec.rb" }
  watch(%r{^providers/(.+)\.rb$})   { |m| "test/unit/lwrps/#{m[1]}_spec.rb" }
  watch(%r{^resources/(.+)\.rb$})   { |m| "test/unit/lwrps/#{m[1]}_spec.rb" }
  watch(%r{^test/unit/(.+)_spec\.rb$})
  watch(%r{^(recipes)/(.+)\.rb$})   { |m| "test/unit/#{m[1]}_spec.rb" }
  watch('test/unit/spec_helper.rb') { 'spec' }
end

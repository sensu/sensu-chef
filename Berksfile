source 'https://supermarket.chef.io'
metadata

group :integration do
  cookbook "sensu-test", path: "test/cookbooks/sensu-test"
end

# changes in chef-vault 3.0 have broken our tests
cookbook 'chef-vault', '< 3.0'

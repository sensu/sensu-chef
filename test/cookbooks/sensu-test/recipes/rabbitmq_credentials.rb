rabbitmq_credentials "test" do
  vhost "test"
  user "testuser"
  password "testpassword"
  permissions ".* .* .*"
end

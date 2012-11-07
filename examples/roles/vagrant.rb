name "vagrant"
description "role for sensu vbox stack"
run_list(
  "role[sensu]",
  "recipe[sensu::redis]",
  "recipe[sensu::rabbitmq]",
  "recipe[sensu::default_handler]",
  "recipe[sensu::default_client]",
  "role[sensu_server]",
  "role[sensu_api]",
  "role[sensu_dashboard]",
  "role[sensu_client]"
)

#!/usr/bin/env bats

@test "should have embedded ruby" {
  [ -x "/opt/sensu/embedded/bin/ruby" ]
}

@test "should have rabbitmq running" {
  [ "$(ps aux | grep rabbitmq-server | grep -v grep)" ]
}

@test "rabbitmq should be listening for connections" {
  [ "$(netstat -plant | grep beam)" ]
}

@test "should have redis-server running" {
  [ "$(ps aux | grep redis-server | grep -v grep)" ]
}

@test "redis-server should be listening for connections" {
  [ "$(netstat -plant | grep redis-server)" ]
}

@test "should have sensu server running under runsv" {
  [ -s /opt/sensu/sv/sensu-server/supervise/pid ]
}

@test "should have sensu api running under runsv" {
  [ -s /opt/sensu/sv/sensu-api/supervise/pid ]
}

@test "should have sensu dashboard running under runsv" {
  [ -s /opt/sensu/sv/sensu-dashboard/supervise/pid ]
}

@test "should have sensu client running under runsv" {
  [ -s /opt/sensu/sv/sensu-client/supervise/pid ]
}

@test "service pids should have changed after restart" {
  run diff /tmp/pre_restart_sensu_pids /tmp/post_restart_sensu_pids
  [ $status -eq 1 ]
}

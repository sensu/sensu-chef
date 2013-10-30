#!/usr/bin/env bats

@test "service pids should have changed after restart" {
  run diff /tmp/pre_restart_sensu_pids /tmp/post_restart_sensu_pids
  [ $status -eq 1 ]
}

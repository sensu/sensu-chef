def dump_sensu_runit_pids(filepath='/tmp/pids')
  require 'yaml'

  pids = {}

  svc_status = Mixlib::ShellOut.new(
    %Q[ /opt/sensu/embedded/bin/sensu-ctl status ]
  ).run_command.stdout.split("\n")

  svc_regex = /run: sensu-(server|api|client|dashboard): \(pid (\d*)\) \d*s/

  svc_status.each do |status|
    match = status.match(svc_regex)
    pids.merge!({ match[1] => match[2] })
  end

  File.open(filepath, "w") do |file|
    file.write pids.to_yaml
  end
end

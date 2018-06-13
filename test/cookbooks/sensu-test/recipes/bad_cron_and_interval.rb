sensu_check "invalid_check_attributes" do
  interval 20
  cron '* * * * *'
  command 'foo bar'
  standalone true
end

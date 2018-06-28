sensu_check "invalid_interval_attribue" do
  interval -10
  command true
  standalone true
end

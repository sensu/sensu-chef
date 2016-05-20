sensu_check "this will fail name validation" do
  interval 20
  command 'true'
  standalone true
end

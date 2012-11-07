sensu_handler :default do
  type 'pipe'
  command "mail -s 'sensu alert' test@example.com"
end

sensu_filter 'always' do
  attributes(:check => { :timestamp => 'eval: true' })
end

sensu_filter 'never' do
  attributes(:check => { :timestamp => 'eval: true' })
  negate true
end

sensu_filter 'daytime' do
  attributes(:check => { :timestamp => 'eval: true' })
  days(:all => [{ :begin => '09:00 AM', :end => '05:00 PM' }])
end

sensu_filter 'nighttime' do
  attributes('check' => { 'timestamp' => 'eval: true' })
  days('all' => [{ 'begin' => '05:00 PM', 'end' => '09:00 AM' }])
end

sensu_filter 'delete_me' do
  action :delete
end

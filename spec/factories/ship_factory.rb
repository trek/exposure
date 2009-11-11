Factory.define :ship do |s|
  s.name 'Black Pearl'
end

Factory.define :dinghy, :class => 'ship' do |s|
  s.name 'A shabby little thing'
end
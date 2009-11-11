Factory.define :pirate do |p|
  p.title 'Captain Jack'
  p.booty 'Rum, Ladies, and a cutlass'
end

Factory.define :pirate_with_ships, :parent => :pirate do |p|
  p.ships {|ships| [ships.association(:ship), ships.association(:dinghy)] }
end
require File.dirname(__FILE__) + '/../spec_helper'

describe "nested builders", :type => :controller do
  setup = lambda {
    class ShipsController < ActionController::Base
      expose_many(:ships, :nested => [:pirates])
    end
    
    ActionController::Routing::Routes.draw do |map| 
      map.resources :pirates do |pirate|
        pirate.resources :ships
      end
    end
  }
  
  setup.call
  controller_name :ships
  Object.remove_class(ShipsController)
  
  before(:each) do
    setup.call
    @controller = ShipsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @pirate = Factory.create(:pirate)
    @ship   = Factory.build(:ship)
    Pirate.stub!(:find).and_return(@pirate)
    @pirate.ships.stub!(:build).and_return(@ship)
    
    
    params = {:pirate_id => @pirate.id, :ship => Factory.attributes_for(:ship)}
    
    get(:new, params)
  end
  
  after(:each) do
    Object.remove_class(ShipsController)
  end
  
  it { should assign_to(:ship).with(@ship) }
  it { should assign_to(:resource).with(@ship) }
  
end

describe "deeply nested builders", :type => :controller do
  setup = lambda {
    class CannonsController < ActionController::Base
      expose_many(:cannons, :nested => [:pirates, :ships])
    end
    
    ActionController::Routing::Routes.draw do |map| 
      map.resources :pirates do |pirate|
        pirate.resources :ships do |ship|
          ship.resources :cannons
        end
      end
    end
  }
  
  setup.call
  controller_name :cannons
  Object.remove_class(CannonsController)
  
  before(:each) do
    setup.call
    @controller = CannonsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @pirate = Factory.create(:pirate)
    @ship   = Factory.create(:ship, :pirate => @pirate)
    @cannon = Factory.build(:cannon)
    
    Pirate.stub!(:find).and_return(@pirate)
    @pirate.ships.stub!(:find).and_return(@ship)
    @ship.cannons.stub!(:build).and_return(@cannon)
    
    
    params = {:pirate_id => @pirate.id, :ship_id => @ship.id, :cannon => Factory.attributes_for(:cannon)}
    
    get(:new, params)
  end
  
  after(:each) do
    Object.remove_class(CannonsController)
  end
  
  it { should assign_to(:cannon).with(@cannon) }
  it { should assign_to(:resource).with(@cannon) }
end
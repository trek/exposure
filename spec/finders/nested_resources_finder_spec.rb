require File.dirname(__FILE__) + '/../spec_helper'

describe "nested finders", :type => :controller do
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
    
    @pirate = Factory.create(:pirate_with_ships)
    @ships = @pirate.ships
    
    get(:index, {:pirate_id => @pirate.id})
  end
  
  after(:each) do
    Object.remove_class(ShipsController)
  end
  
  it { should assign_to(:ships).with(@ships)}
  it { should assign_to(:resources).with(@ships) }
  
end
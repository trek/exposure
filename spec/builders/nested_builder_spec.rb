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
    
    @pirate = Factory.create(:pirate_with_ships)
    Pirate.stub(:find => @pirate)
    
    get(:new, {:pirate_id => 1, :ship => nil})
  end
  
  after(:each) do
    Object.remove_class(ShipsController)
  end
  
  it { should assign_to(:ships) }
  it { should assign_to(:resources) }
  
end
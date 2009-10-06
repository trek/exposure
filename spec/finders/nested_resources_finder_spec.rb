require File.dirname(__FILE__) + '/../spec_helper'

describe "nested finders", :type => :controller do   
  class ShipsController < ActionController::Base
    expose_many(:ships, :nested => [:pirates])
  end 
  
  controller_name :ships

  before(:each) do
    @controller = ShipsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionController::Routing::Routes.draw do |map| 
      map.resources :pirates do |pirate|
        pirate.resources :ships
      end
    end
    
    @pirate = Factory.create(:pirate_with_ships)
    Pirate.stub(:find => @pirate)
    
    get(:index, {:pirate_id => 1})
  end
  
  it { should assign_to(:ships) }
  it { should assign_to(:resources) }
  
end
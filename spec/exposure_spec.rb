require File.dirname(__FILE__) + '/spec_helper.rb'

describe "exposure", :type => :controller do
  setup = lambda {
    class ShipTypesController < ActionController::Base
      expose_many(:ship_types)
    end
  }
  setup.call
  controller_name :ship_types
  Object.remove_class(ShipTypesController)
  
  ActionController::Routing::Routes.draw do |map| 
    map.resources :ship_types
  end
  
  before(:each) do
    setup.call
    @controller = ShipTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  after(:each) do
    Object.remove_class(ShipTypesController)
  end
  
  describe "parent models" do
    it "should constantize resource name" do
      ShipTypesController.resources_name.should == "ship_types"
      ShipTypesController.parent_model.should == ShipType
    end
  end
end

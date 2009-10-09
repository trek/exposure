require File.dirname(__FILE__) + '/spec_helper.rb'

describe "exposure", :type => :controller do
  class ShipTypesController < ActionController::Base
    expose_many(:ship_types)
  end 
  controller_name :ship_types
  
  before(:each) do
    @controller = ShipTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionController::Routing::Routes.draw do |map| 
      map.resources :ship_types
    end
  end
  
  describe "parent models" do
    it "should constantize resource name" do
      ShipTypesController.resources_name.should == "ship_types"
      ShipTypesController.parent_model.should == ShipType
    end
  end
end

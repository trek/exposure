require File.dirname(__FILE__) + '/spec_helper.rb'

describe "included actions" do
  AllActions = [:index, :show, :new, :create, :edit, :update, :destroy]
  IncludedActions = [:new, :show]
  ExcludedActions = AllActions - IncludedActions
  
  setup = lambda {
    class ShipTypesController < ActionController::Base
      expose_many(:ship_types, :only => IncludedActions)
    end 
  }
  
  setup.call
  
  ActionController::Routing::Routes.draw do |map| 
    map.resources :ship_types
  end
  
  Object.remove_class(ShipTypesController)
  
  before(:each) do
    setup.call
    @controller = ShipTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  after(:each) do
    Object.remove_class(ShipTypesController)
  end

  IncludedActions.each do |action|
    it "should have action #{action}" do
      @controller.should respond_to(action)
    end
  end

  ExcludedActions.each do |action|
    it "should have not action #{action}" do
      @controller.should_not respond_to(action)
    end
  end
end

describe "excluded actions" do
  setup = lambda {
    class ShipTypesController < ActionController::Base
      expose_many(:ship_types, :except => ExcludedActions)
    end 
  }
  setup.call
  
  ActionController::Routing::Routes.draw do |map| 
    map.resources :ship_types
  end
  
  Object.remove_class(ShipTypesController)
  
  before(:each) do
    setup.call
    @controller = ShipTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  after(:each) do
    Object.remove_class(ShipTypesController)
  end
  
  IncludedActions.each do |action|
    it "should have action #{action}" do
      @controller.should respond_to(action)
    end
  end
  
  ExcludedActions.each do |action|
    it "should have not action #{action}" do
      @controller.should_not respond_to(action)
    end
  end
end
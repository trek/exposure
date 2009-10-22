require File.dirname(__FILE__) + '/spec_helper.rb'

describe "actions" do
  AllActions = [:index, :show, :new, :create, :edit, :update, :destroy]
  IncludedActions = [:new, :show]
  ExcludedActions = AllActions - IncludedActions
  
  before(:all) do
    class ShipTypesController < ActionController::Base
      expose_many(:ship_types, :only => IncludedActions)
    end
  end
  
  before(:each) do
    @controller = ShipTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionController::Routing::Routes.draw do |map| 
      map.resources :ship_types
    end
  end
  
  after(:all) do
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
  before(:all) do
    class ShipTypesController < ActionController::Base
      expose_many(:ship_types, :except => ExcludedActions)
    end
  end
  
  before(:each) do
    @controller = ShipTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionController::Routing::Routes.draw do |map| 
      map.resources :ship_types
    end
  end
  
  after(:all) do
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
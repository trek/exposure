require File.dirname(__FILE__) + '/responding_behavior'
require File.dirname(__FILE__) + '/../spec_helper'

describe "responders", :type => :controller do
  setup = lambda {
    class PiratesController < ActionController::Base
      expose_many(:pirates)
    end 
  }
  setup.call
  
  ActionController::Routing::Routes.draw do |map| 
    map.resources :pirates, :collection => {:test => :any}
  end
  
  def setup_responder(action, success = nil)
    PiratesController.response_for :create, :on => success do
       redirect_to({:action => 'test'})
    end
  end
  
  controller_name :pirates
  Object.remove_class(PiratesController)
  
  before(:each) do
    setup.call
    @controller = PiratesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @pirate = Factory.stub(:pirate)
    Pirate.stub(:new => @pirate)
  end
  
  after(:each) do
    Object.remove_class(PiratesController)
  end
  
  it_should_behave_like "a responder"
  
end
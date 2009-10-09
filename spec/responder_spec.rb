require File.dirname(__FILE__) + '/spec_helper'

describe "responders'", :type => :controller do   
  class PiratesController < ActionController::Base
    expose_many(:pirates)
    private
      def custom_response
        redirect_to({:action => "test"})
      end
  end 
  controller_name :pirates
  
  before(:each) do
    @controller = PiratesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionController::Routing::Routes.draw do |map| 
      map.resources :pirates, :collection => {:test => :any}
    end
    
    Pirate.stub(:find, Factory.stub(:pirate))
  end
  
  it "can respond to multiple actions with the same method, proc, or block" do
    PiratesController.response_for :show, :new, :is => :custom_response
    get(:show, {:id => 1})
    should respond_with(:redirect).to(:test)
    get(:new)
    should respond_with(:redirect).to(:test)
  end
end
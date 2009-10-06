require File.dirname(__FILE__) + '/../spec_helper'

describe "responders", :type => :controller do   
  class PiratesController < ActionController::Base
    expose_many(:pirates)
  end 
  
  controller_name :pirates
  
  before(:each) do
    @controller = PiratesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionController::Routing::Routes.draw do |map| 
      map.resources :pirates, :collection => {:test => :any}
    end
    @response_proc = Proc.new { redirect_to({:action => "test"}) }
    @pirate = Factory.stub(:pirate)
    Pirate.stub(:new => @pirate)
  end
  
  after(:each) do
    PiratesController::Responses[true].clear
    PiratesController::Responses[false].clear
  end
  
  describe "responding with a method call" do
    before(:each) do
      PiratesController.response_for :create, :is => @response_proc
    end
    
    it "should respond with redirect to test on success" do
      @pirate.stub(:save => true)
      post(:create)
      should redirect_to({:action => 'test'})
    end
    
    it "should respond with redirect to test on failure" do
      @pirate.stub(:save => false)
      post(:create)
      should redirect_to({:action => 'test'})
    end
  end
  
  describe "responding with a method call :on => :success" do
    before(:each) do
       PiratesController.response_for :create, :is => @response_proc, :on => :success
     end

    it "should respond with custom response on success" do
       @pirate.stub(:save => true)
       post(:create)
       should redirect_to({:action => 'test'})
     end

    it "should not respond with custom response on failure" do
       @pirate.stub(:save => false)
       post(:create)
       should_not redirect_to({:action => 'test'})
     end
  end
  
  describe "responding with a method call :on => :failure" do
      before(:each) do
        PiratesController.response_for :create, :is => @response_proc, :on => :failure
      end

      it "should not respond with custom response  on success" do
        @pirate.stub(:save => true)
        post(:create)        
        should_not redirect_to({:action => 'test'})
      end

      it "should respond with custom response on failure" do
        @pirate.stub(:save => false)
        post(:create)
        should redirect_to({:action => 'test'})
      end
    end
end
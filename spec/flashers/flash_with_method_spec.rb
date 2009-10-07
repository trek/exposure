require File.dirname(__FILE__) + '/../spec_helper'

describe "flash messages with methods", :type => :controller do   
  class PiratesController < ActionController::Base
    expose_many(:pirates)
    private
      def custom_flash_message
        'the flash was set'
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
    
    @custom_flash_message = 'the flash was set'
    
    @pirate = Factory.stub(:pirate)
    Pirate.stub(:new => @pirate)
  end
  
  after(:each) do
    PiratesController::FlashMessages[true].clear
    PiratesController::FlashMessages[false].clear
  end
  
  describe "responding with a method call" do
    before(:each) do
      PiratesController.flash_for :create, :is => :custom_flash_message
    end
    
    it "should respond with redirect to test on success" do
      @pirate.stub(:save => true)
      post(:create)
      should set_the_flash.to(@custom_flash_message)
    end
    
    it "should respond with redirect to test on failure" do
      @pirate.stub(:save => false)
      post(:create)
      should set_the_flash.to(@custom_flash_message)
    end
  end
  
  describe "responding with a method call :on => :success" do
    before(:each) do
       PiratesController.flash_for :create, :is => :custom_flash_message, :on => :success
     end

    it "should respond with custom response on success" do
       @pirate.stub(:save => true)
       post(:create)
       should set_the_flash.to(@custom_flash_message)
     end

    it "should not respond with custom response on failure" do
       @pirate.stub(:save => false)
       post(:create)
       should_not redirect_to({:action => 'test'})
     end
  end
  
  describe "responding with a method call :on => :failure" do
      before(:each) do
        PiratesController.flash_for :create, :is => :custom_flash_message, :on => :failure
      end

      it "should not respond with custom response  on success" do
        @pirate.stub(:save => true)
        post(:create)        
        should_not redirect_to({:action => 'test'})
      end

      it "should respond with custom response on failure" do
        @pirate.stub(:save => false)
        post(:create)
        should set_the_flash.to(@custom_flash_message)
      end
    end
end
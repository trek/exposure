require File.dirname(__FILE__) + '/../spec_helper'

describe "flash messages with blocks", :type => :controller do
  setup = lambda {
    class PiratesController < ActionController::Base
      expose_many(:pirates)
      PiratesController.flash_for :create do
        "the flash is set to #{@pirate.title}"
      end
    end 
  }
  setup.call
  
  ActionController::Routing::Routes.draw do |map| 
    map.resources :pirates, :collection => {:test => :any}
  end
  
  controller_name :pirates
  Object.remove_class(PiratesController)
  
  before(:each) do
    setup.call
    @controller = PiratesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @pirate = Factory.stub(:pirate, {:title => 'Captain'})
    Pirate.stub(:new => @pirate)
    
    @pirate.stub(:save => true)
    
    @custom_flash_message = "the flash is set to #{@pirate.title}"
    
    post(:create)
  end
  
  after(:each) do
    Object.remove_class(PiratesController)
  end
  
  it { should set_the_flash.to(@custom_flash_message) }
end
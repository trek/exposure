require File.dirname(__FILE__) + '/flashing_behavior'
require File.dirname(__FILE__) + '/../spec_helper'

describe "flash messages with strings", :type => :controller do
  setup = lambda {
    class PiratesController < ActionController::Base
      expose_many(:pirates)
    end
    
    ActionController::Routing::Routes.draw do |map| 
      map.resources :pirates, :collection => {:test => :any}
    end
  }
  setup.call
  controller_name :pirates
  Object.remove_class(PiratesController)
  
  def setup_flasher(action, success = nil)
    PiratesController.flash_for action, :is => 'the flash was set', :on => success
  end
  
  before(:each) do
    setup.call
    @controller = PiratesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @custom_flash_message = 'the flash was set'
    
    @pirate = Factory.stub(:pirate)
    Pirate.stub(:new => @pirate)
  end
  
  after(:each) do
    Object.remove_class(PiratesController)
  end
  
  it_should_behave_like "a flasher"
  
end
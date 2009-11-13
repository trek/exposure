require File.dirname(__FILE__) + '/flashing_behavior'
require File.dirname(__FILE__) + '/../spec_helper'

describe "flash messages with blocks", :type => :controller do
  setup = lambda {
    class PiratesController < ActionController::Base
      expose_many(:pirates)
    end 
  }
  setup.call
  
  def setup_flasher(action, success = nil)
    PiratesController.flash_for action, :on => success do
      "the flash is set to #{@pirate.title}"
    end
  end
  
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
  
  it_should_behave_like "a flasher"
end
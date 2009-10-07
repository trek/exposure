require File.dirname(__FILE__) + '/../spec_helper'

describe "flash messages with blocks", :type => :controller do   
  class PiratesController < ActionController::Base
    expose_many(:pirates)
    PiratesController.flash_for :create do
      "the flash is set to #{@pirate.title}"
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
    
    @pirate = Factory.stub(:pirate, {:title => 'Captain'})
    Pirate.stub(:new => @pirate)
    
    @pirate.stub(:save => true)
    
    @custom_flash_message = "the flash is set to #{@pirate.title}"
    
    post(:create)
  end
  
  it { should set_the_flash.to(@custom_flash_message) }
end
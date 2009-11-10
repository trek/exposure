require File.dirname(__FILE__) + '/../spec_helper'

describe "builders", :type => :controller do 
  setup = lambda {
    class PiratesController < ActionController::Base
      expose_many(:pirates)
      private
        def build_pirate
          Pirate.new(params[:pirate])
        end
    end
    
    ActionController::Routing::Routes.draw do |map| 
      map.resources :pirates
    end
  }
  
  setup.call
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
  
  it "builds with a proc" do
    PiratesController.build :pirate, :with => Proc.new { Pirate.new(params[:pirate]) }
    post(:create, {:pirate => {}}).inspect
    
    should assign_to(:pirate).with(@pirate)
  end
  
  it "finds with a method name as symbol" do
    PiratesController.build :pirate, :with => :build_pirate
    post(:create, {:pirate => {}})
    
    should assign_to(:pirate).with(@pirate)    
  end
  
  it "finds with a block" do
    PiratesController.build :pirate do
      Pirate.new(params[:pirate])
    end
    
    post(:create, {:pirate => {}})
    
    should assign_to(:pirate).with(@pirate)    
  end
end
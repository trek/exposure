require File.dirname(__FILE__) + '/../spec_helper'

describe "finders", :type => :controller do
  setup = lambda {
    class PiratesController < ActionController::Base
      expose_many(:pirates)
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
    @pirates = [Factory.stub(:pirate)]
    Pirate.stub(:find => @pirate)
    Pirate.stub(:all  => @pirates)
  end
  
  after(:each) do
    Object.remove_class(PiratesController)
  end
  
  it "finds member resource params[:id]" do
    Pirate.should_receive(:find).with('1').and_return(@pirate)
    get(:show, {:id => '1'})    
    should assign_to(:pirate).with(@pirate)
  end
  
  it "finds the collection resource with Model.all" do
    Pirate.should_receive(:all).and_return(@pirates)
    get(:index)    
    should assign_to(:pirates).with(@pirates)
  end
end
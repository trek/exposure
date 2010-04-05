require File.dirname(__FILE__) + '/../spec_helper'

describe "finders", :type => :controller do
  setup = lambda {
    class PiratesController < ActionController::Base
      expose_many(:pirates)
      private
        def find_pirate
          Pirate.find_by_title(params[:id])
        end
        
        def find_pirates
          Pirate.all
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
    @pirates = [Factory.stub(:pirate)]
    Pirate.stub(:find_by_title => @pirate)
    Pirate.stub(:all => @pirates)
  end
  
  after(:each) do
    Object.remove_class(PiratesController)
  end
  
  it "finds member resource with a method name as symbol" do
    PiratesController.find :pirate, :with => proc { Pirate.find_by_title(params[:id]) }
    get(:show, {:id => 'Captain'})
    
    should assign_to(:pirate).with(@pirate)
  end
  
  it "finds collection resource with a method name as symbol" do
    PiratesController.find :pirates, :with => proc { [:all] }
    get(:index)
    
    should assign_to(:pirates).with(@pirates)
  end
  
  it "finds member resource with a proc" do
    PiratesController.find :pirate, :with => :find_pirate
    get(:show, {:id => 'Captain'})
    
    should assign_to(:pirate).with(@pirate)    
  end
  
  it "finds collection resource with a proc" do
    PiratesController.find :pirates, :with => :find_pirates
    get(:index)
    
    should assign_to(:pirates).with(@pirates)    
  end
  
  it "finds member resource with a block" do
    PiratesController.find :pirate do
      Pirate.find_by_title(params[:id])
    end
    
    get(:show, {:id => 'Captain'})
    
    should assign_to(:pirate).with(@pirate)    
  end
  
  it "finds collection resource with a block" do
    PiratesController.find :pirates do
      [:all]
    end
    
    get(:index)
    
    should assign_to(:pirates).with(@pirates)    
  end
end
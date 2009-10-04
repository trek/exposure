require File.dirname(__FILE__) + '/../spec_helper'

describe "finders", :type => :controller do   
  class PiratesController < ActionController::Base
    expose_many(:pirates)
    private
      def find_pirate
        Pirate.find_by_title(params[:id])
      end
  end 
  
  controller_name :pirates

  before(:each) do
    @controller = PiratesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionController::Routing::Routes.draw do |map| 
      map.resources :pirates
    end
    
    @pirate = Factory.stub(:pirate)
    Pirate.stub(:find_by_title => @pirate)
  end
  
  after(:each) do
    PiratesController::Finders.clear
  end
  
  it "finds with a method name as symbol" do
    PiratesController.find :pirate, :with => Proc.new { Pirate.find_by_title(params[:id]) }
    get(:show, {:id => 'Captain'})
    
    should assign_to(:pirate).with(@pirate)
  end
  
  it "finds with a proc" do
    PiratesController.find :pirate, :with => :find_pirate
    get(:show, {:id => 'Captain'})
    
    should assign_to(:pirate).with(@pirate)    
  end
  
  it "finds with a block" do
    PiratesController.find :pirate do
      Pirate.find_by_title(params[:id])
    end
    
    get(:show, {:id => 'Captain'})
    
    should assign_to(:pirate).with(@pirate)    
  end
end
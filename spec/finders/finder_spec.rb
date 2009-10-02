require File.dirname(__FILE__) + '/../spec_helper'

describe "call chain finders", :type => :controller do   
  class PiratesController < ActionController::Base
    expose_many(:pirates)
    find :pirates, :with => [ :active ]
    find :pirate,  :with => [ :find_by_name, params[:id] ]
    find :pirate,  :with => [ :find_by_name, params[:pirate][:name] ]
    
  end 
  
  controller_name :pirates

  before(:each) do
    @controller = PiratesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionController::Routing::Routes.draw do |map| 
      map.resources :pirates
    end
  end
  
  it "should use the custom collection finder" do
    PiratesController.find(:pirates, :with => [:active])
    Pirate.should_receive(:active).and_return([Factory.build(:pirate)])
    get(:index)
  end
  
  it "should use the custome member finder" do
    Pirate.should_receive(:find_by_name).with('jack').and_return(Factory.build(:pirate))
    get(:show, {:id => 'jack'})
  end
  
  it "should use the custome member finder" do
    Pirate.should_receive(:find_by_name).with('jack').and_return(Factory.build(:pirate))
    get(:show, {:id => '1', :pirate => {:name => 'jack'}})
  end
end
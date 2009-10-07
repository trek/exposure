require File.dirname(__FILE__) + '/../spec_helper'

describe "mime type responders", :type => :controller do   
  class PiratesController < ActionController::Base
    expose_many(:pirates)
  end 
  
  controller_name :pirates
  
  before(:each) do
    @controller = PiratesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionController::Routing::Routes.draw do |map| 
      map.resources :pirates, :collection => {:test => :any}
    end
    @pirate = Factory.stub(:pirate)
     Pirate.stub(:new => @pirate)
  end
  
  after(:each) do
    PiratesController::Responses.clear
  end
  
  it "should respond with not acceptable if no acceptable mime type is not found" do
    @request.accept = "application/x-yaml"
    @pirate.stub(:save => true)
    post(:create)        
    should respond_with(:not_acceptable)
  end
  
  it "should respond with mime type when header is set" do
    @request.accept = 'application/xml'
    @pirate.stub(:save => true)
    post(:create)        
    should respond_with_content_type(:xml) 
  end
  
  it "should respond with mime type when params[:format] is set" do
    @pirate.stub(:save => true)
    post(:create, {:format => 'xml'})            
    should respond_with_content_type(:xml) 
  end
end
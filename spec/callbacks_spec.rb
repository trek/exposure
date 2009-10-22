require File.dirname(__FILE__) + '/spec_helper.rb'

describe "callbacks'", :type => :controller do
  setup = lambda {
    class PiratesController < ActionController::Base
      expose_many(:pirates)
      private
        def first_callback_called
          @callback_called = 1
        end

        def second_callback_called
          @callback_called +=  1
        end

        def third_callback_called
          @callback_called +=  1
        end
    end 
  }
  setup.call
  
  ActionController::Routing::Routes.draw do |map| 
    map.resources :pirates
  end
  
  controller_name :pirates
  Object.remove_class(PiratesController)
  
  before(:each) do
    setup.call
    @controller = PiratesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  after(:each) do
    Object.remove_class(PiratesController)
  end
    
  it "can call multiple callbacks" do
    PiratesController.after :assign, :first_callback_called, :second_callback_called, :third_callback_called
    get(:new)
    should assign_to(:callback_called).with(3)  
  end
end
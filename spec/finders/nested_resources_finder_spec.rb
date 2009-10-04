require File.dirname(__FILE__) + '/../spec_helper'

describe "nested finders", :type => :controller do   
  class PirateShipsController < ActionController::Base
    expose_many(:ships, :nested => :pirate)
    private
      def find_pirate
        Pirate.find_by_title(params[:id])
      end
  end 
  
  controller_name :pirate_ships

  before(:each) do
    @controller = PirateShipsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionController::Routing::Routes.draw do |map| 
      map.resources :pirates do |pirate|
        pirate.resources :ships
      end
    end
    
    @ship   = Factory.stub(:ship)
    @pirate = Factory.stub(:pirate, {:ships => []})
    Pirate.stub(:find_by_title => @pirate)
  end
  
  it { should assign_to(:ship).with(@ship) }
end
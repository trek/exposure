require File.dirname(__FILE__) + '/spec_helper'

describe "a REST patterned resource of 'pirates'", :type => :controller do   
  class PiratesController < ActionController::Base
    expose_many(:pirates)
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
  
  describe 'configuration' do
    it "has a resource name of 'post'" do
      @controller.send(:resource_name).should == 'pirate'
    end
  
    %w(index show new create edit update destroy).each do |action|
      it "has the REST action #{action}" do
        @controller.should respond_to(action)
      end
    end
  end
  
  describe 'index' do
    before do
      get :index
    end

    it { should assign_to(:pirates) }
    it { should assign_to(:resources) }
    it { should respond_with(:success) }
    it { should render_template(:index) }
    it { should_not set_the_flash }
  end
  
  describe 'show' do
    describe 'with found resource' do
      before(:each) do
        Pirate.should_receive(:find).with('1').and_return(Factory.stub(:pirate))
        get :show, {:id => 1}
      end
      
      it { should assign_to(:pirate) }
      it { should assign_to(:resource) }
      it { should respond_with(:success) }
      it { should render_template(:show) }
      it { should_not set_the_flash }
    end
    
    describe 'with missing resource' do
      before(:each) do
        rescue_action_in_public!
        Pirate.should_receive(:find).with('1').and_raise(ActiveRecord::RecordNotFound)
        get :show, {:id => 1}
      end
      
      it { should_not assign_to(:pirate) }
      it { should_not assign_to(:resource) }
      it { should respond_with(:not_found) }
      it { should_not render_template(:show) }
      it { should_not set_the_flash }
    end
  end
  
  describe 'new' do
    before(:each) do
      get :new
    end
    
    it { should assign_to(:pirate) }
    it { should assign_to(:resource) }
    it { should respond_with(:success) }
    it { should render_template(:new) }
    it { should_not set_the_flash }
    
  end
  
  describe 'create' do
    describe 'with valid data' do
      before(:each) do
        params = {
          :pirate => {}
        }
        post_before_saving = Factory.build(:pirate)
        Pirate.should_receive(:new).with(params[:pirate]).and_return(post_before_saving)
        post_before_saving.should_receive(:save).and_return(true)
        post(:create, params)
      end
      
      it { should assign_to(:pirate) }
      it { should assign_to(:resource) }
      it { should respond_with(:redirect).to(:index) }
      it { should set_the_flash.to('Pirate successfully created') }
    end
    
    describe 'with invalid data' do
      before(:each) do
        params = {
          :pirate => {}
        }
        post_before_saving = Factory.build(:pirate)
        Pirate.should_receive(:new).with(params[:pirate]).and_return(post_before_saving)
        post_before_saving.should_receive(:save).and_return(false)
        post(:create, params)
      end
      
      it { should assign_to(:pirate) }
      it { should assign_to(:resource) }
      it { should respond_with(:success) }
      it { should render_template(:new) }
      it { should_not set_the_flash }
    end
  end
  
  describe 'edit' do
    describe 'with found resource' do
      before(:each) do
        Pirate.should_receive(:find).with('1').and_return(Factory.stub(:pirate))
        get :edit, {:id => 1}
      end
      
      it { should assign_to(:pirate) }
      it { should assign_to(:resource) }
      it { should respond_with(:success) }
      it { should render_template(:edit) }
      it { should_not set_the_flash }
    end
    
    describe 'with missing resource' do
      before(:each) do
        rescue_action_in_public!
        Pirate.should_receive(:find).with('1').and_raise(ActiveRecord::RecordNotFound)
        get :edit, {:id => 1}
      end
      
      it { should_not assign_to(:pirate) }
      it { should_not assign_to(:resource) }
      it { should respond_with(:not_found) }
      it { should_not render_template(:edit) }
      it { should_not set_the_flash }
    end
  end
  
  describe 'update' do
    describe 'with valid data' do
      before(:each) do
        params = {
          :id  => 1,
          :pirate => {}
        }
        post_before_saving = Factory.build(:pirate)
        Pirate.should_receive(:find).with("1").and_return(post_before_saving)
        post_before_saving.should_receive(:update_attributes).with(params[:pirate]).and_return(true)
        put(:update, params)
      end
      
      it { should assign_to(:pirate) }
      it { should assign_to(:resource) }
      it { should respond_with(:redirect).to(:show) }
      it { should set_the_flash.to('Pirate successfully updated') }
      
    end
    
    describe 'with invalid data' do
      before(:each) do
        params = {
          :id  => 1,
          :pirate => {}
        }
        post_before_saving = Factory.build(:pirate)
        Pirate.should_receive(:find).with("1").and_return(post_before_saving)
        post_before_saving.should_receive(:update_attributes).with(params[:pirate]).and_return(false)
        put(:update, params)
      end
      
      it { should assign_to(:pirate) }
      it { should assign_to(:resource) }
      it { should respond_with(:success) }
      it { should render_template(:edit) }
      it { should_not set_the_flash }
    end
  end
  
  describe 'destroy' do
    before(:each) do
      params = {
        :id  => 1,
      }
      post_before_saving = Factory.build(:pirate)
      Pirate.should_receive(:find).with("1").and_return(post_before_saving)
      post_before_saving.should_receive(:destroy)
      delete(:destroy, params)
    end
    
    it { should respond_with(:redirect).to(:index) }
    it { should set_the_flash.to('Pirate successfully removed') }
  end
end
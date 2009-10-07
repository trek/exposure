# require File.dirname(__FILE__) + '/spec_helper'
# 
# describe "a REST patterned resource of 'post'", :type => :controller do
#   class ShipController < ActionController::Base
#     expose_one :ship
#   end
#   controller_name :ship
#   
#   before(:each) do
#     @controller = ShipController.new
#     @request    = ActionController::TestRequest.new
#     @response   = ActionController::TestResponse.new
#     ActionController::Routing::Routes.draw do |map| 
#       map.resource :ship
#     end
#   end
#   
#   describe 'configuration' do
#     it "has a resource name of 'post'" do
#       @controller.send(:resource_name).should == 'ship'
#     end
#   
#     %w(show new create edit update destroy).each do |action|
#       it "has the REST action #{action}" do
#         @controller.should respond_to(action)
#       end
#     end
#   end
#   
#   describe 'show' do
#     describe 'with found resource' do
#       before(:each) do
#         Ship.should_receive(:find).with('1').and_return(Factory.stub(:ship))
#         get :show, {:id => 1}
#       end
#       
#       it { should assign_to(:ship) }
#       it { should assign_to(:resource) }
#       it { should respond_with(:success) }
#       it { should render_template(:show) }
#       it { should_not set_the_flash }
#     end
#     
#     describe 'with missing resource' do
#       before(:each) do
#         rescue_action_in_public!
#         Ship.should_receive(:find).with('1').and_raise(ActiveRecord::RecordNotFound)
#         get :show, {:id => 1}
#       end
#       
#       it { should_not assign_to(:ship) }
#       it { should_not assign_to(:resource) }
#       it { should respond_with(:not_found) }
#       it { should_not render_template(:show) }
#       it { should_not set_the_flash }
#     end
#   end
#   
#   describe 'new' do
#     before(:each) do
#       get :new
#     end
#     
#     it { should assign_to(:ship) }
#     it { should assign_to(:resource) }
#     it { should respond_with(:success) }
#     it { should render_template(:new) }
#     it { should_not set_the_flash }
#     
#   end
#   
#   describe 'create' do
#     describe 'with valid data' do
#       before(:each) do
#         params = {
#           :ship => {}
#         }
#         post_before_saving = Factory.build(:ship)
#         Ship.should_receive(:new).with(params[:ship]).and_return(post_before_saving)
#         post_before_saving.should_receive(:save).and_return(true)
#         post(:create, params)
#       end
#       
#       it { should assign_to(:ship) }
#       it { should assign_to(:resource) }
#       it { should respond_with(:redirect).to(:show) }
#       it { should set_the_flash.to('Ship successfully created') }
#     end
#     
#     describe 'with invalid data' do
#       before(:each) do
#         params = {
#           :ship => {}
#         }
#         post_before_saving = Factory.build(:ship)
#         Ship.should_receive(:new).with(params[:ship]).and_return(post_before_saving)
#         post_before_saving.should_receive(:save).and_return(false)
#         post(:create, params)
#       end
#       
#       it { should assign_to(:ship) }
#       it { should assign_to(:resource) }
#       it { should respond_with(:success) }
#       it { should render_template(:new) }
#       it { should_not set_the_flash }
#     end
#   end
#   
#   describe 'edit' do
#     describe 'with found resource' do
#       before(:each) do
#         Ship.should_receive(:find).with('1').and_return(Factory.stub(:ship))
#         get :edit, {:id => 1}
#       end
#       
#       it { should assign_to(:ship) }
#       it { should assign_to(:resource) }
#       it { should respond_with(:success) }
#       it { should render_template(:edit) }
#       it { should_not set_the_flash }
#     end
#     
#     describe 'with missing resource' do
#       before(:each) do
#         rescue_action_in_public!
#         Ship.should_receive(:find).with('1').and_raise(ActiveRecord::RecordNotFound)
#         get :edit, {:id => 1}
#       end
#       
#       it { should_not assign_to(:ship) }
#       it { should_not assign_to(:resource) }
#       it { should respond_with(:not_found) }
#       it { should_not render_template(:edit) }
#       it { should_not set_the_flash }
#     end
#   end
#   
#   describe 'update' do
#     describe 'with valid data' do
#       before(:each) do
#         params = {
#           :id  => 1,
#           :ship => {}
#         }
#         post_before_saving = Factory.build(:ship)
#         Ship.should_receive(:find).with("1").and_return(post_before_saving)
#         post_before_saving.should_receive(:update_attributes).with(params[:ship]).and_return(true)
#         put(:update, params)
#       end
#       
#       it { should assign_to(:ship) }
#       it { should assign_to(:resource) }
#       it { should respond_with(:redirect).to(:show) }
#       it { should set_the_flash.to('Ship successfully updated') }
#       
#     end
#     
#     describe 'with invalid data' do
#       before(:each) do
#         params = {
#           :id  => 1,
#           :ship => {}
#         }
#         post_before_saving = Factory.build(:ship)
#         Ship.should_receive(:find).with("1").and_return(post_before_saving)
#         post_before_saving.should_receive(:update_attributes).with(params[:ship]).and_return(false)
#         put(:update, params)
#       end
#       
#       it { should assign_to(:ship) }
#       it { should assign_to(:resource) }
#       it { should respond_with(:success) }
#       it { should render_template(:edit) }
#       it { should_not set_the_flash }
#     end
#   end
#   
#   describe 'destroy' do
#     before(:each) do
#       params = {
#         :id  => 1,
#       }
#       post_before_saving = Factory.build(:ship)
#       Ship.should_receive(:find).with("1").and_return(post_before_saving)
#       post_before_saving.should_receive(:destroy)
#       delete(:destroy, params)
#     end
#     
#     it { should respond_with(:redirect).to(:new) }
#     it { should set_the_flash.to('Ship successfully removed') }
#   end
# end

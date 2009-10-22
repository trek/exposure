$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'action_controller'
require 'exposure/configuration'
require 'exposure/behaviors/building'
require 'exposure/behaviors/callbacks'
require 'exposure/behaviors/finding'
require 'exposure/behaviors/flashing'
require 'exposure/behaviors/responding'

require 'exposure/patterns/resources'

module Exposure
  VERSION = '0.0.6'
  def self.included(base)
    base.extend Configuration
  end
end
ActionController::Base.send :include, Exposure

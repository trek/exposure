$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'exposure/configuration'
require 'exposure/common'
require 'exposure/patterns/resources'
require 'exposure/patterns/resource'

module Exposure
  VERSION = '0.0.1'
  def self.included(base)
    base.extend Configuration
  end
end
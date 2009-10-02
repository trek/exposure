RAILS_ROOT = '.'    unless defined? RAILS_ROOT
RAILS_ENV  = 'test' unless defined? RAILS_ENV

module Rails
  module VERSION
    STRING = '2.3.4'
  end
end


require 'rubygems'
# require 'multi_rails_init'

require 'rubygems'
require 'action_controller'
require 'action_view'
require 'active_record'
require 'test_help'

require 'spec'
require File.dirname(__FILE__) + '/spec_rails_helper'
require 'shoulda'
require File.dirname(__FILE__) + "/custom_matchers"
require 'factory_girl'


$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'exposure'

ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV['DEBUG']
ActionController::Base.logger = Logger.new(STDOUT) if ENV['DEBUG']
ActionController::Base.send :include, Exposure
ActionController::Base.view_paths=(File.dirname(__FILE__) + '/fixtures')

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define(:version => 1) do
  create_table :pirates do |t|
    t.column :title,        :string
    t.column :booty,        :text
    t.column :created_at,   :datetime
    t.column :updated_at,   :datetime
  end
  create_table :ships do |t|
    t.column :name,         :string
    t.column :pirate_id,    :integer
    t.column :created_at,   :datetime
    t.column :updated_at,   :datetime
  end
  create_table :widgets do |t|
    t.column :title,        :string
    t.column :body,         :text
    t.column :created_at,   :datetime
    t.column :updated_at,   :datetime
  end
end

class Pirate < ActiveRecord::Base
  has_one :ship
  validates_length_of :title, :within => 2..100
  def validate
  end
end

class Ship < ActiveRecord::Base
  belongs_to :pirate
  def validate
  end
  validates_associated :pirate
end
# class Comment < ActiveRecord::Base
#   belongs_to :post
#   def validate
#   end
#   validates_associated :post
# end
# 
# class Widget < ActiveRecord::Base
#   def validate
#   end
# end

class PostsController < ActionController::Base
end
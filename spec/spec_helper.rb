RAILS_ROOT = '.'    unless defined? RAILS_ROOT
RAILS_ENV  = 'test' unless defined? RAILS_ENV

module Rails
  module VERSION
    STRING = '2.3.4' unless defined? STRING
  end
end


# require 'multi_rails_init'

require 'rubygems'
require 'action_controller'
require 'action_view'
require 'active_record'

require 'spec'
require File.dirname(__FILE__) + '/spec_rails_helper'
require 'shoulda'
require File.dirname(__FILE__) + '/custom_matchers'
require 'factory_girl'


$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'exposure'

ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV['DEBUG']
ActionController::Base.logger = Logger.new(STDOUT) if ENV['DEBUG']
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
  create_table :cannons do |t|
    t.column :name,        :string
    t.column :ship_id,      :integer
    t.column :created_at,   :datetime
    t.column :updated_at,   :datetime
  end
  create_table :ship_types do |t|
    t.column :title,        :string
    t.column :body,         :text
    t.column :created_at,   :datetime
    t.column :updated_at,   :datetime
  end
end

class Cannon < ActiveRecord::Base
  belongs_to :ship
  def validate
  end
end

class Pirate < ActiveRecord::Base
  has_many :ships
  validates_length_of :title, :within => 2..100
  def validate
  end
end

class Ship < ActiveRecord::Base
  belongs_to :pirate
  has_many :cannons
  def validate
  end
  validates_associated :pirate
end

class ShipType < ActiveRecord::Base
end
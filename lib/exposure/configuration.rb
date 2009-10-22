module Exposure
  module Configuration  
    # options
    # :nested => false or symbol or array of symbols
    #   defaults to false
    # :only   => array of REST methods names as symbols to only include
    #   defaults to [:index, :show, :new, :create, :edit, :update, :destroy]
    # :except => array of REST methods to exclude
    #   defaults to [ ]
    # :formats => array of 
    #   defaults to [ :html, :xml]
    # 
    def expose_many(name, options = {})
      @_exposed_resource_name = name
      @_exposed_resource_options = options
      
      extend Configuration::Options
      
      class << self
        attr_accessor :resource_name, :resources_name, 
                      :resource_chain, :resources_chain, 
                      :collection_nesting, :member_nesting,
                      :parent_model
      end
      
      include ActiveSupport::Callbacks
      include Exposure::Finding
      include Exposure::Flashing
      include Exposure::Responding
      include Exposure::Callbacks
      
      self.name!
      self.build_default_finders!
      self.build_default_builders!
      
      extend  Patterns::Resources
      include Patterns::Resources::Actions
      
      self.allow_actions!
      self.allow_formats!
      
      define_callbacks(*Patterns::Resources::Callbacks)
    end
    alias :expose :expose_many
  end
end
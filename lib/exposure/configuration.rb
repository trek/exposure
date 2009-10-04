module Exposure
  module Configuration
    def resource_name
      @resource_name
    end
    
    def resource_name=(name)
      @resource_name = name
    end
    
    def resources_name
      @resources_name
    end
    
    def resources_name=(name)
      @resources_name = name
    end
    
    # options
    # :nested => false or symbol or array of symbols
    #   defaults to false
    # :only   => array of REST methods names as symbols to only include
    #   defaults to [:show, :new, :create, :edit, :update, :destroy]
    # :except => array of REST methods to exclude
    #   defaults to [ ]
    # :formats => array of 
    #   defaults to [ :html, :xml, :json ]
    #
    def expose_one(resource_name, options = {})
      include ActiveSupport::Callbacks      
      extend Exposure::Common
      self.resource_name = resource_name
      
      extend  Patterns::Resource
      include Patterns::Resource::Actions
      
      define_callbacks(*Patterns::Resource::Callbacks)
    end
    
    # options
    # :nested => false or symbol or array of symbols
    #   defaults to false
    # :only   => array of REST methods names as symbols to only include
    #   defaults to [:index, :show, :new, :create, :edit, :update, :destroy]
    # :except => array of REST methods to exclude
    #   defaults to [ ]
    # :formats => array of 
    #   defaults to [ :html, :xml, :json ]
    # 
    def expose_many(name, options = {})
      include ActiveSupport::Callbacks      
      self.resource_name  = name.to_s.singularize
      self.resources_name = name.to_s
      
      extend Exposure::Common
      extend  Patterns::Resources
      include Patterns::Resources::Actions
      
      define_callbacks(*Patterns::Resources::Callbacks)
    end
  end
end
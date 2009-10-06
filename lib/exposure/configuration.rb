module Exposure
  module Configuration
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
      self.member_nesting = [ [self.resource_name.to_sym] ]

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
      extend Exposure::Common
      
      self.resource_name  = name.to_s.singularize
      self.resources_name = name.to_s
      
      if nesting = options[:nested]
        
        self.parent_model = nesting.shift.to_s.singularize.capitalize.constantize
        
        build_default_finders(self.resources_name, nesting)
        
        nesting.collect! {|sym| [sym.to_s.singularize.to_sym, sym]}
        self.member_nesting = nesting + [ [self.resource_name.to_sym] ]
        self.collection_nesting = nesting + [ [self.resources_name.to_sym] ]
      else
        self.parent_model = self.resource_name.capitalize.constantize
        build_default_finders(self.resource_name, [])
        self.member_nesting = [ [self.resource_name.to_sym] ]
        self.collection_nesting = [ [self.resources_name.to_sym] ]
      end
      
      extend  Patterns::Resources
      include Patterns::Resources::Actions
      
      define_callbacks(*Patterns::Resources::Callbacks)
    end
  end
end
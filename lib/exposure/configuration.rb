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
      
      self.resource_name  = name.to_s.singularize
      self.resources_name = name.to_s
      
      if nesting = options[:nested]
        
        self.parent_model = nesting.shift.to_s.singularize.camelize.constantize
        
        build_default_finders(self.resources_name, nesting)
        
        nesting.collect! {|sym| [sym.to_s.singularize.to_sym, sym]}
        self.member_nesting = nesting + [ [self.resource_name.to_sym] ]
        self.collection_nesting = nesting + [ [self.resources_name.to_sym] ]
      else
        self.parent_model = self.resource_name.camelize.constantize
        build_default_finders(self.resource_name, [])
        self.member_nesting = [ [self.resource_name.to_sym] ]
        self.collection_nesting = [ [self.resources_name.to_sym] ]
      end
      
      extend  Patterns::Resources
      include Patterns::Resources::Actions
      
      if options[:only]
        options[:except] = Patterns::Resources::DefaultActions - options[:only]
      end
      
      if options[:except]
        options[:except].each do |action|
          undef_method(action)
        end
      end
      
      define_callbacks(*Patterns::Resources::Callbacks)
    end
    alias :expose :expose_many
  end
end
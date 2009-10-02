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
    
    def expose_one(resource_name, options = {})
      include ActiveSupport::Callbacks      
      extend Exposure::Common
      self.resource_name = resource_name
      
      extend  Patterns::Resource
      include Patterns::Resource::Actions
      
      define_callbacks(*Patterns::Resource::Callbacks)
    end
    
    def expose_many(name, options = {})
      include ActiveSupport::Callbacks      
      self.resource_name  = name.to_s.singularize
      self.resources_name = name.to_s
      
      extend Exposure::Common
      extend  Patterns::Resources
      include Patterns::Resources::Actions
      
      define_callbacks(*Patterns::Resources::Callbacks)
      
    end
    
    # def expose(resource_name, options = {})
    #   include ActiveSupport::Callbacks      
    #   extend Exposure::Common
    #   
    #   self.resource_name = resource_name
    #   
    #   extend  Patterns::Resources
    #   include Patterns::Resources::Actions
    #   
    #   define_callbacks(*Patterns::Resources::Callbacks)
    #   
    # end
    
    # def include_and_extend
    #   extend  Patterns::Resources
    #   include Patterns::Resources::Actions
    # end
    
  end
end
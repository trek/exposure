module Exposure
  module Configuration
    module Options
      def allow_actions!
        if @_exposed_resource_options[:only]
          @_exposed_resource_options[:except] = Patterns::Resources::DefaultActions - @_exposed_resource_options[:only]
        end
        
        if @_exposed_resource_options[:except]
          @_exposed_resource_options[:except].each do |action|
            undef_method(action)
          end
        end
      end
      
      def allow_formats!
        formats = @_exposed_resource_options[:formats] || [:html, :xml] 
      end
      
      def name!
        self.resource_name  = @_exposed_resource_name.to_s.singularize
        self.resources_name = @_exposed_resource_name.to_s
      end
      
      def build_default_finders!
        if nesting = @_exposed_resource_options[:nested]
          self.build_nested_default_finders!(nesting)
          return 
        end
        
        self.parent_model = self.resource_name.camelize.constantize
        build_default_finders(self.resource_name, [])
        self.member_nesting = [ [self.resource_name.to_sym] ]
        self.collection_nesting = [ [self.resources_name.to_sym] ]
      end
      
      def build_default_builders!
        if nesting = @_exposed_resource_options[:nested]
          self.build_nested_default_builders!(nesting)
          return 
        end
        
        self.parent_model = self.resource_name.camelize.constantize
        build_default_builder(self.resource_name, [])
        self.member_nesting = [ [self.resource_name.to_sym] ]
        self.collection_nesting = [ [self.resources_name.to_sym] ]
      end
      
      def build_nested_default_builders!(nesting)
        build_default_builder(self.resources_name, nesting)
      end
      
      def build_nested_default_finders!(nesting)
        
        self.parent_model = nesting.shift.to_s.singularize.camelize.constantize
        
        build_default_finders(self.resources_name, nesting)
        
        nesting.collect! {|sym| [sym.to_s.singularize.to_sym, sym]}
        
        self.member_nesting = nesting + [ [self.resource_name.to_sym] ]
        self.collection_nesting = nesting + [ [self.resources_name.to_sym] ]
      end
    end
  end
end
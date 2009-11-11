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
    end
  end
end
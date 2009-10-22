module Exposure
  module Building
    def self.included(base)
      base.extend ClassMethods
      base.send(:include, InstaneMethods)
    end
    
    module ClassMethods
      def build(name, options = {}, &block)
        options[:with] ||= block
        self.const_get(:Builders)[name] = options[:with]
      end
      
      def build_default_builder(member, nesting)
        self::const_set(:DefaultBuilder, {
          self.resource_name.intern  => Proc.new { [:new, params[resource_name] ] }
        })
      end
    end
    
    module InstaneMethods
      private
        def custom_builder_for(resource_name)
          
        end
        
        def default_builder_for(resource_name)
          
        end
        
        def builder_for(resource_name)
          custom_builder_for(resource_name) || default_builder_for(resource_name)
        end
    end
  end
end
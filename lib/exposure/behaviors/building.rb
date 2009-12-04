module Exposure
  module Building
    def self.included(base)
      base.extend ClassMethods
      base.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      def build(name, options = {}, &block)
        options[:with] ||= block
        self.const_get(:Builders)[name] = options[:with]
      end
      
      def build_default_builders!
        nesting = @_exposed_resource_options[:nested] || []
        nesting = nesting.clone
        build_default_builder(self.resources_name, nesting)
      end
      
      def build_default_builder(member, nesting)
        if nesting.any?
          builders = self::const_set(:DefaultBuilders, {
            self.resource_name.intern  => Proc.new { [:build, params[resource_name] ] },
          })
        else
          self::const_set(:DefaultBuilders, {
            self.resource_name.intern  => Proc.new { [:new, params[resource_name] ] },
          })
        end
      end
    end
    
    module InstanceMethods
      private
        def custom_builder_for(resource_name)
          if builder = self.class::Builders[resource_name]
            return builder
          end
        end
        
        def default_builder_for(resource_name)
          if builder = self.class::DefaultBuilders[resource_name]
            return builder
          end
        end
        
        def builder_for(resource_name)
          custom_builder_for(resource_name) || default_builder_for(resource_name) || finder_for(resource_name)
        end
        
        def call_builder_chain(object, chain, use_associaiton = true)
          chain = chain.clone
          links = chain.shift
          return object unless links
          
          message = builder_for(links[0])
          association = links[1] if use_associaiton
          
          case message
          when Symbol
            value = self.send(message)
          when Proc
            value = self.instance_eval(&message)
          else
            raise "invalid builder of #{message.inspect}"
          end
          
          if value.kind_of?(Array) && !value.respond_to?(:proxy_target)
            if use_associaiton
              call_builder_chain(object.send(association).send(*value), chain)
            else
              call_builder_chain(object.send(*value), chain)
            end
          else
            call_builder_chain(value, chain)
          end
        end
    end
  end
end
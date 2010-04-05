module Exposure
  module Finding
    def self.included(base)
      base.extend ClassMethods
      base.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      # find :person, :with => proc { Person.find_by_permalink(params[:permalink]) }
      # find :people, :with => proc { Person.send(params[:scope]) }
      # find :dogs, :with => :dogs_adopted_after_date
      # find :dogs do
      #   Dog.all
      # end
      # 
      # valid options are
      #   :with
      #   :only (unimplemented)
      #   :except (unimplemented)
      def find(name, options = {}, &block)
        options[:with] ||= block
        self.const_get(:Finders)[name] = options[:with]
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
      
      def build_nested_default_finders!(nesting)
        nesting = nesting.clone
        self.parent_model = nesting.first.to_s.singularize.camelize.constantize
        
        build_default_finders(self.resources_name, nesting)
        
        nesting.collect! {|sym| [sym.to_s.singularize.to_sym, sym]}
        
        
        self.member_nesting = nesting + [ [self.resource_name.to_sym, self.resources_name.to_sym] ]
        self.collection_nesting = nesting + [ [self.resources_name.to_sym, self.resources_name.to_sym] ]
      end
      
      def build_default_finders(member, nesting) #:nodoc:
        finders = self::const_set(:DefaultFinders, {
          self.resource_name.intern  => proc { [:find, params[:id] ] },
          self.resources_name.intern => proc { [:all] }
        })

        nesting.each do |association_name|
          finders[association_name.to_s.singularize.to_sym] = proc { [:find, params[:"#{association_name.to_s.singularize}_id"]] }
          finders[association_name] = proc { [ :all ] }
        end
      end
    end
    
    module InstanceMethods
      private
        def custom_finder_for(resource_name)
          if finder = self.class::Finders[resource_name]
            return finder
          end
        end
        
        def default_finder_for(resource_name)
          if finder = self.class::DefaultFinders[resource_name]
            return finder
          end
        end
        
        def finder_for(resource_name)
          custom_finder_for(resource_name) || default_finder_for(resource_name)
        end
        
        def call_finder_chain(object, chain, use_associaiton = true)
          chain = chain.clone
          links = chain.shift
          return object unless links
          
          message = finder_for(links[0])
          association = links[1] if use_associaiton
          
          case message
          when Symbol
            value = self.send(message)
          when Proc
            value = self.instance_eval(&message)
          else
            raise "invalid finder of #{message.inspect}"
          end
          
          if value.kind_of?(Array) && !value.respond_to?(:proxy_target)
            if use_associaiton
              call_finder_chain(object.send(association).send(*value), chain)
            else
              return value if value.empty? || value[0].kind_of?(ActiveRecord::Base) # the find already executed
              call_finder_chain(object.send(*value), chain)
            end
          else
            call_finder_chain(value, chain)
          end
        end
    end
  end
end
module Exposure
  module Callbacks
    def self.included(base)
      base.extend ClassMethods
      base.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      # access point for creating and configuring before_ callbacks.
      def before(trigger, *actions)
        options = actions.extract_options!
        actions.each do |action|
          build_callback('before', trigger, action, options)
        end
      end
      
      # access point for creating and configuring after_ callbacks.
      def after(trigger, *actions)
        options = actions.extract_options!
        actions.each do |action|
          build_callback('after', trigger, action, options)
        end
      end
      
      # builds callbacks that adhere to the ActiveSupport::Callbacks interface
      def build_callback(prefix, trigger, action, options) #:nodoc:
        callback_name = "#{prefix}_#{trigger}"
        
        if options[:on]
          callback_name += "_on_#{options.delete(:on)}"
        end
        
        options[:if] ||= []
        
        only_methods = Array.wrap(options.delete(:only))
        except_methods = Array.wrap(options.delete(:except))
        
        if only_methods.any?
          options[:if] << proc {|c| only_methods.include?(c.action_name.intern) }
        end
        
        if except_methods.any?
          options[:if] << proc {|c| !except_methods.include?(c.action_name.intern) }
        end
        
        self.send(callback_name, action, options)
      end
    end
    
    module InstanceMethods
    end
  end
end
module Exposure
  module Callbacks
    def self.included(base)
      base.extend ClassMethods
      base.send(:include, InstaneMethods)
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
        
        only_methods = options.delete(:only)
        except_methods = options.delete(:except)
        
        if only_methods
          options[:if] << Proc.new {|c| only_methods.include?(c.action_name.intern) }
        end
        
        if except_methods
          options[:if] << Proc.new {|c| !except_methods.include?(c.action_name.intern) }
        end
        
        self.send(callback_name, action, options)
      end
    end
    
    module InstaneMethods
    end
  end
end
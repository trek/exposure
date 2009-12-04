module Exposure
  module Flashing
    def self.included(base)
      base.extend ClassMethods
      base.send(:include, InstanceMethods)
    end
    
    module ClassMethods
      # configure flash messages
      # valid action names are 
      #   :index :show :new :create :edit :update :destroy
      # valid options are
      #   :on (optional)
      #     :success, :failure, :any
      #     default is :any
      #   :is (optional if block given)
      #     can be a Proc or method name as symbol.
      def flash_for(action_name, options = {}, &block)
        options[:is] ||= block
        
        case options[:on]
        when NilClass, :any
          self.const_get(:FlashMessages)["#{action_name}.success.html"]  = options[:is]
          self.const_get(:FlashMessages)["#{action_name}.failure.html"]  = options[:is]
        when :success
          self.const_get(:FlashMessages)["#{action_name}.success.html"]  = options[:is]
        when :failure
          self.const_get(:FlashMessages)["#{action_name}.failure.html"]  = options[:is]
        end
      end
    end
    
    module InstanceMethods
      private
        def custom_flash_for(action_name, action_status)
          if flash_message = self.class::FlashMessages["#{action_name}.#{action_status}.html"]
            case flash_message
            when String
              flash[:notice] = flash_message
            when Symbol
              flash[:notice] = self.send(flash_message)
            when Proc
              flash[:notice] = self.instance_eval(&flash_message)
            end
          else
            false
          end
        end
        
        def default_flash_for(action_name, action_status)
          if message_proc = self.class::DefaultFlashMessages["#{action_name}.#{action_status}.html"]
            flash[:notice] = self.instance_eval(&message_proc)
          end
        end
        
        def flash_for(action_name, action_successful)
          custom_flash_for(action_name, action_successful) || default_flash_for(action_name, action_successful)
        end
    end
    
  end
end
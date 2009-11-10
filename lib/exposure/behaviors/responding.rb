module Exposure
  module Responding
    def self.included(base)
      base.extend ClassMethods
      base.send(:include, InstaneMethods)
    end
    
    module ClassMethods
      # response_for :create, :on => :success, :is => { proc }
      # response_for :show, :formats => [:html] do
      #   @resource.activated ? render('show') : render('next_steps')
      # end
      # response_for :new, :is => :new_foo_built
      #
      # valid action names are 
      #   :index :show :new :create :edit :update :destroy
      # valid options are
      #   :on (optional)
      #     :success, :failure, :any
      #     default is :any
      #   :is (option if block given)
      #     can be a Proc or method name as symbol.
      #   :formats
      #     array of formats as symbols.
      #     defaults to [:html]
      def response_for(*actions, &block)
        options = actions.extract_options!
        options[:is] ||= block
        formats  = options[:formats] || [:html]
        
        case options[:on]
        when NilClass, :any
          build_custom_response(actions, :success, formats, options[:is])
          build_custom_response(actions, :failure, formats, options[:is])
        when :success
          build_custom_response(actions, :success, formats, options[:is])
        when :failure
          build_custom_response(actions, :failure, formats, options[:is])
        end
      end
      
      def build_custom_response(action_names, success_status, formats, response) #:nodoc:
        action_names.each do |action_name|
          formats.each do |format|
            self.const_get(:Responses)["#{action_name}.#{success_status}.#{format}"] = response
          end
        end
      end
    end
    
    module InstaneMethods
      private
        def custom_response_for(action_name, action_status, format)
          if responder = self.class::Responses["#{action_name}.#{action_status}.#{format}"]
            case responder
            when Symbol
              self.send(responder)
            when Proc
              self.instance_eval &responder
            end
          else
            false
          end
        end
        
        def default_response_for(action_name, action_status, format)
          if responder = self.class::DefaultResponses["#{action_name}.#{action_status}.#{format}"]
            self.instance_eval &responder
          else
            return false
          end
        end
        
        def response_for(action_name, action_status, format = :html)
          format = :html if format == :all
          custom_response_for(action_name, action_status, format) || default_response_for(action_name, action_status, format) || head(:not_acceptable)
        end
    end
  end
end
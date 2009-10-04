module Exposure
  module Common    
    def respond_to(action_name, options = {}, &block)
      options[:with] ||= block
      
      case options[:on]
      when NilClass
        self.const_get(:Responses)[true][action_name]  = options[:with]
        self.const_get(:Responses)[false][action_name] = options[:with]
      when :success
        self.const_get(:Responses)[true][action_name]  = options[:with]
      when :failure
        self.const_get(:Responses)[false][action_name] = options[:with]
      end
    end
    
    # find :person, :with => Proc.new { Person.find_by_permalink(params[:permalink]) }
    # find :people, :with => Proc.new { Person.send(params[:scope]) }
    # find :dogs, :with => :dogs_adopted_after_date
    # find :dogs do
    #   Dog.all
    # end
    # 
    # valid options are
    #   :with
    #   :only
    #   :except
    def find(name, options = {}, &block)
      options[:with] ||= block
      self.const_get(:Finders)[name] = options[:with]
    end
    
    # configure flash messages
    def flash_for(action_name, options = {}, &block)
      options[:with] ||= block
      
      case options[:on]
      when NilClass
        self.const_get(:FlashMessages)[true][action_name]  = options[:with]
        self.const_get(:FlashMessages)[false][action_name] = options[:with]
      when :success
        self.const_get(:FlashMessages)[true][action_name]  = options[:with]
      when :failure
        self.const_get(:FlashMessages)[false][action_name] = options[:with]
      end
    end
    
    # access point for creating and configuring before_ callbacks.
    def before(trigger, action, options = {})
      build_callback('before', trigger, action, options)
    end
    
    # access point for creating and configuring before_ callbacks.
    def after(trigger, action, options = {})
      build_callback('after', trigger, action, options)
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
end
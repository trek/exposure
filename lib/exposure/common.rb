module Exposure
  module Common
    class <<
      attr_accessor :resource_name, :resources_name, 
                    :resource_chain, :resources_chain, 
                    :collection_nesting, :member_nesting,
                    :parent_model
    end
    
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
    def response_for(action_name, options = {}, &block)
      options[:is] ||= block
      formats  = options[:formats] || [:html]
      
      case options[:on]
      when NilClass, :any
        build_custom_response(action_name, :success, formats, options[:is])
        build_custom_response(action_name, :failure, formats, options[:is])
      when :success
        build_custom_response(action_name, :success, formats, options[:is])
      when :failure
        build_custom_response(action_name, :failure, formats, options[:is])
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
    #   :only (unimplemented)
    #   :except (unimplemented)
    def find(name, options = {}, &block)
      options[:with] ||= block
      self.const_get(:Finders)[name] = options[:with]
    end
    
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
        self.const_get(:FlashMessages)[true][action_name]  = options[:is]
        self.const_get(:FlashMessages)[false][action_name] = options[:is]
      when :success
        self.const_get(:FlashMessages)[true][action_name]  = options[:is]
      when :failure
        self.const_get(:FlashMessages)[false][action_name] = options[:is]
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
    
    # builds default finders
    def build_default_finders(member, nesting) #:nodoc:
      finders = self::const_set(:DefaultFinders, {
        self.resource_name.intern  => Proc.new { [:find, params[:id] ] },
        self.resources_name.intern => Proc.new { [:all] }
      })
      
      nesting.each do |association_name|
        finders[association_name.to_s.singularize.to_sym] = Proc.new { [:find, params[:"#{association_name.to_s.singularize}_id"]] }
        finders[association_name] = Proc.new { [ :all ] }
      end
    end
    
    def build_custom_response(action_name, success_status, formats, response)
      formats.each do |format|
        self.const_get(:Responses)["#{action_name}.#{success_status}.#{format}"] = response
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
end
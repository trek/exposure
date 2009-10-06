module Exposure
  module Patterns
    module Resources
      def self.extended(base)
        base::const_set(:DefaultResponses, DefaultResponses)
        base::const_set(:DefaultFlashMessages, DefaultFlashMessages)
        base::const_set(:Finders, { true => {}, false => {} })
        base::const_set(:FlashMessages, { true => {}, false => {} })
        base::const_set(:Responses, { true => {}, false => {} } )
      end
      
      Callbacks = %w(
        before_find after_find after_find_on_failure after_find_on_success
        before_find_many after_find_many after_find_many_on_failure after_find_many_on_success
        before_assign after_assign
        before_save after_save after_save_on_failure after_save_on_success
        before_create after_create_on_failure after_create_on_success
        before_update after_update_on_failure after_update_on_success
        before_destroy after_destroy_on_success
        before_response before_response_on_success before_response_on_failure
      )
      
      DefaultFlashMessages = {
        true => {
          :create => Proc.new { "#{resource_name.capitalize} successfully created" },
          :update => Proc.new { "#{resource_name.capitalize} successfully updated" },
          :destroy => Proc.new { "#{resource_name.capitalize} successfully removed" }
        },
        false => {}
      }
      
      DefaultResponses = {
        true =>  {
          :index => Proc.new   { render('index')        },
          :show  => Proc.new   { render('show')        },
          :new   => Proc.new   { render('new')         },
          :create => Proc.new  { redirect_to({:action => 'index'})  },
          :edit   => Proc.new  { render('edit')        },
          :update => Proc.new  { redirect_to({:action => 'show' })   },
          :destroy => Proc.new { redirect_to({:action => 'index'}) }
        },
        false => {
          :create => Proc.new { render('new')    },
          :update => Proc.new { render('edit')   }
        }
      }

      module Actions
        def index
          run_callbacks(:before_find_many)
           if find_records
             run_callbacks(:after_find_many_on_success)
             run_callbacks(:after_find_many)
             run_callbacks(:before_response)
             run_callbacks(:before_response_on_success)
             response_for(:index, true)
           else
             run_callbacks(:after_find_many_on_failure)
             run_callbacks(:after_find_many)
             run_callbacks(:before_response)
             run_callbacks(:before_response_on_failure)
             response_for(:index, false)
          end
        end
        
        def show
          run_callbacks(:before_find)
          if find_record
            run_callbacks(:after_find_on_success)
            run_callbacks(:after_find)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_success)
            response_for(:show, true)
          else
            run_callbacks(:after_find_on_failure)
            run_callbacks(:after_find)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_failure)
            response_for(:show, false)
          end
        end
        
        def new
          run_callbacks(:before_assign)
          new_record
          run_callbacks(:after_assign)
          run_callbacks(:before_response)
          run_callbacks(:before_response_on_success)
          response_for(:new, true)
        end
        
        def create
          run_callbacks(:before_assign)
          new_record
          run_callbacks(:after_assign)

          run_callbacks(:before_create)
          run_callbacks(:before_save)

          if save_record
            run_callbacks(:after_save_on_success)
            run_callbacks(:after_create_on_success)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_success)
            flash_for(:create, true)
            response_for(:create, true)
          else
            run_callbacks(:after_save_on_failure)
            run_callbacks(:after_create_on_failure)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_failure)
            flash_for(:create, false)
            response_for(:create, false)
          end
          
        end
        
        def edit
          run_callbacks(:before_find)
          if find_record
            run_callbacks(:after_find_on_success)
            run_callbacks(:after_find)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_success)
            response_for(:edit, true)
          else
            run_callbacks(:after_find_on_failure)
            run_callbacks(:after_find)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_failure)
            response_for(:edit, false)
          end
        end
        
        def update
          run_callbacks(:before_find)
          if find_record
            run_callbacks(:after_find_on_success)
            run_callbacks(:after_find)
            if update_record
              run_callbacks(:after_save_on_success)
              run_callbacks(:after_update_on_success)
              run_callbacks(:before_response)
              run_callbacks(:before_response_on_success)
              flash_for(:update, true)
              response_for(:update, true)
            else
              run_callbacks(:after_save_on_failure)
              run_callbacks(:after_create_on_failure)
              run_callbacks(:before_response)
              run_callbacks(:before_response_on_failure)
              flash_for(:update, false)
              response_for(:update, false)
            end
          else
            run_callbacks(:after_find_on_failure)
            run_callbacks(:after_find)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_failure)
            response_for(:edit, false)
          end
        end
        
        def destroy
          run_callbacks(:before_find)
          if find_record
            run_callbacks(:after_find_on_success)
            run_callbacks(:after_find)
            run_callbacks(:before_destroy)

            delete_record

            run_callbacks(:after_destroy_on_success)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_success)
            flash_for(:destroy, true)
            response_for(:destroy, true)

          else
            run_callbacks(:after_find_on_failure)
            run_callbacks(:after_find)
            response_for(:destroy, false)
          end
        end
        
        private
          def custom_response_for(action_name, action_successful)
            if finder = self.class::Responses[action_successful][action_name]
              case finder
              when Symbol
                self.send(finder)
              when Proc
                self.instance_eval &finder
              end
            else
              false
            end
          end

          def default_response_for(action_name, action_successful)
            if finder = self.class::DefaultResponses[action_successful][action_name]
               self.instance_eval &finder
            else
              return false
            end
          end

          def response_for(action_name, action_successful)
            custom_response_for(action_name, action_successful) || default_response_for(action_name, action_successful)
          end
          
          def custom_flash_for(action_name, action_successful)
            if flash_message = self.class::FlashMessages[action_successful][action_name]
              case flash_message
              when String
                flash[:message] = flash_message
              when Symbol
                flash[:message] = self.send(flash_message)
              when Proc
                flash[:message] = self.instance_eval(&flash_message)
              end
            else
              false
            end
          end
          
          def default_flash_for(action_name, action_successful)
            if message_proc = self.class::DefaultFlashMessages[action_successful][action_name]
              flash[:message] = self.instance_eval(&message_proc)
            end
          end
          
          def flash_for(action_name, action_successful)
            custom_flash_for(action_name, action_successful) || default_flash_for(action_name, action_successful)
          end
          
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
                call_finder_chain(object.send(*value), chain)
              end
            else
              call_finder_chain(value, chain)
            end
          end
          
          def builder_for(resource_name)
            custom_builder_for(resource_name) || default_builder_for(resource_name)
          end
          
          def resource_name
            self.class.resource_name
          end
          
          def resources_name
            self.class.resources_name
          end
          
          def save_record
            @resource.save
          end
          
          def update_record
            @resource.update_attributes(params[resource_name])
          end
          
          def new_record
            @resource = instance_variable_set("@#{resource_name}", self.class.parent_model.new(params[resource_name]))
          end
          
          def find_record
            @resource = instance_variable_set("@#{resource_name}", call_finder_chain(self.class.parent_model, self.class.member_nesting.clone, false))
          end
          
          def find_records            
            @resources = instance_variable_set("@#{resources_name}", call_finder_chain(self.class.parent_model, self.class.collection_nesting.clone, false))
          end
          
          def delete_record
            @resource.destroy
          end
      end
    end
  end
end
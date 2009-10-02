module Exposure
  module Patterns
    module Resource
      def self.extended(base)
        base::const_set(:DefaultResponses, DefaultResponses)
        base::const_set(:DefaultFlashMessages, DefaultFlashMessages)
        base::const_set(:DefaultFinders, {
          base.resource_name => Proc.new {|parent,controller| parent.find(controller.params[:id])},
        })
      end
      
      Callbacks = %w(
        before_find after_find after_find_on_failure after_find_on_success
        before_assign after_assign
        before_save after_save after_save_on_failure after_save_on_success
        before_create after_create_on_failure after_create_on_success
        before_update after_update_on_failure after_update_on_success
        before_destroy after_destroy_on_success
        before_response before_response_on_success before_response_on_failure
      )
      
      DefaultFlashMessages = {
        true => {
          :create => Proc.new {|c| "#{c.send(:resource_name).capitalize} successfully created" },
          :update => Proc.new {|c| "#{c.send(:resource_name).capitalize} successfully updated" },
          :destroy => Proc.new {|c| "#{c.send(:resource_name).capitalize} successfully removed" }
        },
        false => {}
      }
      
      DefaultResponses = {
        true =>  {
          :show  => Proc.new   {|c| c.send(:render, 'show')        },
          :new   => Proc.new   {|c| c.send(:render, 'new')         },
          :create => Proc.new  {|c| c.send(:redirect_to, {:action => 'show'})  },
          :edit   => Proc.new  {|c| c.send(:render, 'edit')        },
          :update => Proc.new  {|c| c.send(:redirect_to, {:action => 'show' })   },
          :destroy => Proc.new {|c| c.send(:redirect_to, {:action => 'new'}) }
        },
        false => {
          :create => Proc.new {|c| c.send(:render, 'new')    },
          :update => Proc.new {|c| c.send(:render, 'edit')   }
        }
      }
    
      module Actions
        # no index on single resources
        
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
            false
          end

          def default_response_for(action_name, action_successful)
            self.class::DefaultResponses[action_successful][action_name].call(self)
          end

          def response_for(action_name, action_successful)
            custom_response_for(action_name, action_successful) || default_response_for(action_name, action_successful)
          end

          def custom_flash_for(action_name, action_successful)
            false
          end

          def default_flash_for(action_name, action_successful)
            if message_proc = self.class::DefaultFlashMessages[action_successful][action_name]
              flash[:message] = message_proc.call(self)
            end
          end

          def flash_for(action_name, action_successful)
            custom_flash_for(action_name, action_successful) || default_flash_for(action_name, action_successful)
          end

          def resource_name
            self.class.resource_name
          end

          def save_record
            @resource.save
          end

          def update_record
            @resource.update_attributes(params[resource_name])
          end

          def new_record
            @resource = instance_variable_set("@#{resource_name}", resource_name.camelize.constantize.new(params[resource_name]))
          end

          def find_record
            @resource = instance_variable_set("@#{resource_name}", resource_name.camelize.constantize.find(params[:id]))
          end

          def find_records
            @resources = instance_variable_set("@#{resource_name.pluralize}", resource_name.camelize.constantize.all)
          end

          def delete_record
            @resource.destroy
          end
        end
    end
  end
end
module Exposure
  module Patterns
    module Resources
      def self.extended(base)
        base::const_set(:DefaultResponses, DefaultResponses)
        base::const_set(:DefaultFlashMessages, DefaultFlashMessages)
        base::const_set(:Finders, { true => {}, false => {} })
        base::const_set(:Builders, {})
        base::const_set(:FlashMessages, {})
        base::const_set(:Responses, {} )
      end
      
      DefaultActions = [:index, :show, :new, :create, :edit, :update, :destroy]
      
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
        'create.success.html' => proc { "#{resource_name.capitalize} successfully created" },
        'update.success.html' => proc { "#{resource_name.capitalize} successfully updated" },
        'destroy.success.html' => proc { "#{resource_name.capitalize} successfully removed" }
      }
      
      DefaultResponses = {
        'index.success.html'  => proc   { render('index') },
        'show.success.html'   => proc   { render('show')  },
        'new.success.html'    => proc   { render('new')   },
        'create.success.html' => proc  { redirect_to({:action => 'index'}) },
        'edit.success.html'   => proc  { render('edit')  },
        'update.success.html' => proc  { redirect_to({:action => 'show' }) },
        'destroy.success.html'=> proc { redirect_to({:action => 'index'}) },
        'create.failure.html' => proc { render('new')    },
        'update.failure.html' => proc { render('edit')   },
        
        'index.success.xml'   => proc { render(:xml => @resources) },
        'show.success.xml'   => proc  { render(:xml => @resource) },
        'new.success.xml'    => proc  { render(:xml => @resource) },
        'create.success.xml' => proc  { render({:xml => @resource, :status => :created, :location => @resource}) },
        'created.failure.xml'=> proc  { render(:xml => @resource.errors, :status => :unprocessable_entity)},
        'update.success.xml' => proc  { head(:ok)},
        'update.failure.xml' => proc  { render(:xml => @resource.errors, :status => :unprocessable_entity)},
        'destroy.success.xml'=> proc  { head(:ok)},
        
        'index.success.json'   => proc { render(:json => @resources) },
        'show.success.json'   => proc  { render(:json => @resource) },
        'new.success.json'    => proc  { render(:json => @resource) },
        'create.success.json' => proc  { render({:json => @resource, :status => :created, :location => @resource}) },
        'created.failure.json'=> proc  { render(:json => @resource.errors, :status => :unprocessable_entity)},
        'update.success.json' => proc  { render(:json => @resource)},
        'update.failure.json' => proc  { render(:json => @resource.errors, :status => :unprocessable_entity)},
        'destroy.success.json'=> proc  { render(:json => @resource)}
        
      }

      module Actions
        def index          
          run_callbacks(:before_find_many)
           if find_records             
             run_callbacks(:after_find_many_on_success)
             run_callbacks(:after_find_many)
             run_callbacks(:before_response)
             run_callbacks(:before_response_on_success)
             response_for(:index, :success, request.format.to_sym)
           else
             run_callbacks(:after_find_many_on_failure)
             run_callbacks(:after_find_many)
             run_callbacks(:before_response)
             run_callbacks(:before_response_on_failure)
             response_for(:index, :failure, request.format.to_sym)
          end
        end
        
        def show
          run_callbacks(:before_find)
          if find_record
            run_callbacks(:after_find_on_success)
            run_callbacks(:after_find)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_success)
            response_for(:show, :success, request.format.to_sym)
          else
            run_callbacks(:after_find_on_failure)
            run_callbacks(:after_find)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_failure)
            response_for(:show, :failure, request.format.to_sym)
          end
        end
        
        def new
          run_callbacks(:before_assign)
          build_record
          run_callbacks(:after_assign)
          run_callbacks(:before_response)
          run_callbacks(:before_response_on_success)
          response_for(:new, :success, request.format.to_sym)
        end
        
        def create
          run_callbacks(:before_assign)
          build_record
          run_callbacks(:after_assign)

          run_callbacks(:before_create)
          run_callbacks(:before_save)

          if save_record
            run_callbacks(:after_save_on_success)
            run_callbacks(:after_create_on_success)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_success)
            flash_for(:create, :success)
            response_for(:create, :success, request.format.to_sym)
          else
            run_callbacks(:after_save_on_failure)
            run_callbacks(:after_create_on_failure)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_failure)
            flash_for(:create, :failure)
            response_for(:create, :failure, request.format.to_sym)
          end
          
        end
        
        def edit
          run_callbacks(:before_find)
          if find_record
            run_callbacks(:after_find_on_success)
            run_callbacks(:after_find)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_success)
            response_for(:edit, :success, request.format.to_sym)
          else
            run_callbacks(:after_find_on_failure)
            run_callbacks(:after_find)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_failure)
            response_for(:edit, :failure, request.format.to_sym)
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
              flash_for(:update, :success)
              response_for(:update, :success, request.format.to_sym)
            else
              run_callbacks(:after_save_on_failure)
              run_callbacks(:after_create_on_failure)
              run_callbacks(:before_response)
              run_callbacks(:before_response_on_failure)
              flash_for(:update, :failure)
              response_for(:update, :failure, request.format.to_sym)
            end
          else
            run_callbacks(:after_find_on_failure)
            run_callbacks(:after_find)
            run_callbacks(:before_response)
            run_callbacks(:before_response_on_failure)
            response_for(:edit, :failure, request.format.to_sym)
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
            flash_for(:destroy, :success)
            response_for(:destroy, :success, request.format.to_sym)

          else
            run_callbacks(:after_find_on_failure)
            run_callbacks(:after_find)
            response_for(:destroy, :failure, request.format.to_sym)
          end
        end
        
        private
          def resource_name
            self.class.resource_name
          end
          
          def resources_name
            self.class.resources_name
          end
          
          def parent_model
            self.class.parent_model
          end
          
          def save_record
            @resource.save
          end
          
          def update_record
            @resource.update_attributes(params[resource_name])
          end
          
          def build_record
            @resource = instance_variable_set("@#{resource_name}", call_builder_chain(parent_model, self.class.member_nesting, false))
          end
          
          def find_record
            @resource = instance_variable_set("@#{resource_name}", call_finder_chain(parent_model, self.class.member_nesting, false))
          end
          
          def find_records        
            @resources = instance_variable_set("@#{resources_name}", call_finder_chain(parent_model, self.class.collection_nesting, false))
          end
          
          def delete_record
            @resource.destroy
          end
      end
    end
  end
end
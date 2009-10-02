# when spec/rails is required it expects to be inside a real Rails application and looks for 
# classes and files that aren't present in the plugin. This is a copy of most of what is
# inside the spec-rails gem's initialization.
class ApplicationController
end

require 'rack/utils'

require 'action_controller/test_process'
require 'action_controller/integration'
require 'active_support/test_case'
require 'active_record/fixtures' if defined?(ActiveRecord::Base)

require 'spec/test/unit'

require 'spec/rails/matchers'
require 'spec/rails/mocks'
require 'spec/rails/example'
require 'spec/rails/extensions'
require 'spec/rails/interop/testcase'

Spec::Example::ExampleGroupFactory.default(ActiveSupport::TestCase)
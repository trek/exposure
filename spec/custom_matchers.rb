module Shoulda
  module ActionController
    module Matchers
      class RespondWithMatcher
        def to(where)
           @location = case where
           when Symbol
             where == :back ? where : {:action => where.to_s}
           else
             where
           end
           self
         end
         
         def description
           description = "respond with #{@status}"
           description << " to #{@location.inspect}" unless @location.nil?
           description
         end
         
         def matches?(controller)
           @controller = controller
           (correct_status_code? || correct_status_code_range?) && correct_redirect_location
         end
         
         def expectation
           expectation = "response to be a #{@status},"
           expectation << " redirecting to #{@location.inspect}, " if @location
           expectation << " but was #{response_code}"
           expectation << " redirected to #{@controller.response.redirected_to.inspect}" if @location
           expectation
         end
         private
           def correct_redirect_location
             return true unless @location
             @controller.response.redirected_to == @location
           end
       end
    end
  end
end
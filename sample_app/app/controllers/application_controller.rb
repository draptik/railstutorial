# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time ## Note: For all
              # Views, not for all Controllers

  ## p. 287 tutorial: The following line also includes the
  ## SessionHelper to all controllers of the application
  include SessionsHelper

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password


end

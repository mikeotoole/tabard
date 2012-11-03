ActiveAdmin.setup do |config|
  # == Site Title
  #
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  config.site_title = "Alexandria"

  # Set the link url for the title. For example, to take
  # users to your main site. Defaults to no link.
  #
  config.site_title_link = "/alexandria"

  # == Default Namespace
  #
  # Set the default namespace each administration resource
  # will be added to.
  #
  # eg:
  #   config.default_namespace = :hello_world
  #
  # This will create resources in the HelloWorld module and
  # will namespace routes to /hello_world/*
  #
  # To set no namespace by default, use:
  #   config.default_namespace = false
  #
  # Default:
  config.default_namespace = :alexandria

  # == User Authentication
  #
  # Active Admin will automatically call an authentication
  # method in a before filter of all controller actions to
  # ensure that there is a currently logged in admin user.
  #
  # This setting changes the method which Active Admin calls
  # within the controller.
  config.authentication_method = :authenticate_admin_user!


  # == Current User
  #
  # Active Admin will associate actions with the current
  # user performing them.
  #
  # This setting changes the method which Active Admin calls
  # to return the currently logged in user.
  config.current_user_method = :current_admin_user


  # == Logging Out
  #
  # Active Admin displays a logout link on each screen. These
  # settings configure the location and method used for the link.
  #
  # This setting changes the path where the link points to. If it's
  # a string, the strings is used as the path. If it's a Symbol, we
  # will call the method to return the path.
  #
  # Default:
  # config.logout_link_path = :destroy_admin_user_session_path

  # This setting changes the http method used when rendering the
  # link. For example :get, :delete, :put, etc..
  #
  # Default:
  # config.logout_link_method = :get


  # == Admin Comments
  #
  # Admin comments allow you to add comments to any model for admin use
  #
  # Admin comments are enabled by default in the default
  # namespace only. You can turn them on in a namesapce
  # by adding them to the comments array.
  #
  # Default:
  # config.allow_comments_in = [:admin]


  # == Controller Filters
  #
  # You can add before, after and around filters to all of your
  # Active Admin resources from here.
  #
  # config.before_filter :do_something_awesome
  config.before_filter :sign_out_current_user
  config.skip_before_filter :authenticate_user!
  config.skip_before_filter :block_unauthorized_user!
  config.skip_before_filter :check_maintenance_mode
  config.skip_before_filter :limit_subdomain_access
  config.skip_before_filter :ensure_not_ssl_mode
  config.before_filter :ensure_secure_subdomain
  config.skip_before_filter :ensure_accepted_most_recent_legal_documents

  ActiveAdmin::Devise::SessionsController.skip_before_filter :check_maintenance_mode
  # ActiveAdmin::Dashboards::DashboardController.before_filter :authorize_dashboard_index, only: :index # TODO: "rails s" explodes on this line

  # == Register Stylesheets & Javascripts
  #
  # We recommend using the built in Active Admin layout and loading
  # up your own stylesheets / javascripts to customize the look
  # and feel.
  #
  # To load a stylesheet:
  #   config.register_stylesheet 'my_stylesheet.css'
  #
  # To load a javascript file:
  #   config.register_javascript 'my_javascript.js'
end

def sign_out_current_user
  if current_user
    sign_out(current_user)
  end
end

def authorize_dashboard_index
  authorize! :index, ActiveAdmin::Dashboards::DashboardController
end

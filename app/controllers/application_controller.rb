class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
  end

  def authorize_admin
    redirect_to root_path, alert: 'Access Denied' unless (current_user && current_user.admin?)
  end

  def authorize_user
    redirect_to root_path, alert: 'Access Denied' unless (current_user)
  end

  def after_sign_in_path_for(resource)
    if current_user.admin
      admin_join_requests_url
    else
      courses_path
    end
  end
end

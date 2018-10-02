class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?

  def index
    render layout: false
  end

  protect_from_forgery
        
  protected  
    def authorize_admin
      redirect_to root_path, alert: 'Access Denied' unless (current_user && current_user.admin?)
    end

    def authorize_user
      redirect_to new_user_session_url, alert: 'Access Denied' unless (current_user)
    end

    def after_sign_in_path_for(resource)
      if current_user.admin
        admin_join_requests_url
      else
        sign_in_url = new_user_session_url
        if request.referer == sign_in_url
          super
        else
          stored_location_for(resource) || request.referer || root_path
        end
      end
    end

    def ssl_configured?
      !Rails.env.development?
    end
    # def after_sign_in_path_for(resource)
    #   sign_in_url = new_user_session_url
    #   if request.referer == sign_in_url
    #     super
    #   else
    #     stored_location_for(resource) || request.referer || root_path
    #   end
    # end
end

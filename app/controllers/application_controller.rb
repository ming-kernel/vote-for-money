class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_i18n_locale_from_parms

  def set_auth_token(user)
    cookies[:auth_token] = user.auth_token
  end
  
  def require_admin
    unless current_user and current_user.name == 'admin'
      redirect_to login_url, :notice => 'You should logged in as admin'
    end
  end

  protected
    def set_i18n_locale_from_parms
      if params[:locale]
        if I18n.available_locales.include?(params[:locale].to_sym)
          I18n.locale = params[:locale]
        else
          flash.now[:notice] = 
            "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end

      def default_url_options
        { locale: I18n.locale }
      end
    end



  private
  
    def current_user
      @current_user ||= User.find_by_auth_token( cookies[:auth_token]) if cookies[:auth_token]
    end

  helper_method :current_user
end

class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?, :admin_signed_in?

  private

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def user_signed_in?
      current_user.present?
    end

    def admin_signed_in?
      current_user&.admin?
    end

    def require_login
      return if user_signed_in?

      redirect_to login_path, alert: "Devam etmek için giriş yapmalısın."
    end

    def require_admin
      return if admin_signed_in?

      redirect_to root_path, alert: "Bu işlem için admin yetkisi gerekiyor."
    end
end

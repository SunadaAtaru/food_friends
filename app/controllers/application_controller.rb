# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # deviseの設定
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: '権限がありません'
    end
  end
end

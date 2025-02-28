# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # deviseの設定
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  private

  def render_404
    render 'errors/not_found', status: :not_found
  end
end

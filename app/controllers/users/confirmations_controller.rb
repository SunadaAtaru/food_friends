# app/controllers/users/confirmations_controller.rb
class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  def new
    super
  end

  # POST /resource/confirmation
  def create
    super
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super do |resource|
      if resource.errors.present?
        redirect_to new_user_confirmation_path, alert: '確認トークンが無効です'
        return
      end
    end
  end

  protected

  def after_confirmation_path_for(_resource_name, resource)
    sign_in(resource)
    flash[:notice] = 'メールアドレスが確認できました'
    root_path
  end
end

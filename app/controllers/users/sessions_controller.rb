class Users::SessionsController < Devise::SessionsController
  protected

  # ログイン後のリダイレクト先をカスタマイズ
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_users_path # 管理者なら管理者専用ページへ
    else
      root_path # 一般ユーザーは通常のトップページへ
    end
  end
end

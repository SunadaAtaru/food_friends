# Deviseのユーザー登録コントローラーをカスタマイズするクラス
class Users::RegistrationsController < Devise::RegistrationsController
  # アカウント更新時にパラメータの設定を行うフィルター
  before_action :configure_account_update_params, only: [:update]
 
  protected
 
  # アカウント更新時に許可する追加のパラメータを設定
  # @param [ActionController::Parameters] devise_parameter_sanitizer パラメータサニタイザー
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :username,           # ユーザー名
      :introduction,       # 自己紹介
      :address,           # 住所
      :contact,           # 連絡先
      :profile_visibility, # プロフィール公開設定
      :avatar             # アバター画像
    ])
  end
 
  # アカウント情報更新後のリダイレクト先を設定
  # @param [User] resource 更新されたユーザーリソース
  # @return [String] リダイレクト先のパス
  def after_update_path_for(resource)
    user_path(resource)  # ユーザーのプロフィールページへリダイレクト
  end
 
  # ユーザー情報の更新処理をカスタマイズ
  # パスワードが空の場合は、現在のパスワード確認なしで更新可能
  # @param [User] resource 更新対象のユーザーリソース
  # @param [Hash] params 更新用パラメータ
  def update_resource(resource, params)
    # パスワード関連のパラメータが空の場合
    if params[:password].blank? && params[:password_confirmation].blank?
      # パスワード確認なしで更新（プロフィール情報のみの更新）
      resource.update_without_password(params.except(:current_password))
    else
      # パスワードを含む更新の場合は現在のパスワード確認が必要
      resource.update_with_password(params)
    end
  end
end
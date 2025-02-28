module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user! # ログイン済みであることを保証
    before_action :admin_user # 管理者であることを確認

    def index
      @users = User.all
    end

    def destroy
      user = User.find(params[:id])
      if user.admin?
        redirect_to admin_users_path, alert: '管理者ユーザーは削除できません。'
      else
        user.destroy
        redirect_to admin_users_path, notice: 'ユーザーを削除しました。'
      end
    end

    private

    def admin_user
      redirect_to root_path, alert: '権限がありません。' unless current_user.admin?
    end
  end
end

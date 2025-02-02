class UsersController < ApplicationController
  before_action :authenticate_user!  # deviseのログイン確認
  before_action :set_user, only: [:show, :edit, :update]  # DRY原則に基づく

  def show
    # プロフィール表示用のアクション
    # @userは:set_userで設定済み
  end

  def edit
    # 編集画面表示用のアクション
    # @userは:set_userで設定済み
    unless @user == current_user
      redirect_to user_path(@user), alert: "他のユーザーのプロフィールは編集できません"
    end
  end

  def update
    if @user == current_user && @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールを更新しました'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :introduction, :address, :contact, :profile_visibility)
  end
end

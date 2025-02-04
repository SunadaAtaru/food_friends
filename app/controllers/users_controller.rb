class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  def show
    # プロフィール表示用
  end

  def edit
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
    params.require(:user).permit(:username, :introduction, :address, 
                               :contact, :profile_visibility, :avatar)
  end
end
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_admin, only: [:destroy]

  def show
    # プロフィール表示用
  end

  def edit
    return if @user == current_user

    redirect_to user_path(@user), alert: '他のユーザーのプロフィールは編集できません'
  end

  def update
    if @user == current_user && @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールを更新しました'
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: "ユーザーを削除しました。"
    else
      redirect_to user_path(@user), alert: "ユーザーの削除に失敗しました。"
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

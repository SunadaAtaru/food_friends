class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update]

  def index
    @users = User.page(params[:page]).per(10) # 1ページに10人表示
  end

  def show; end

  def edit
    return if @user == current_user

    redirect_to root_path, alert: '他のユーザーのプロフィールは編集できません'
  end

  def update
    if @user == current_user && @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "ユーザーが見つかりません"
    redirect_to root_path and return
  end
  

  def user_params
    params.require(:user).permit(:username, :introduction, :address,
                                 :contact, :profile_visibility, :avatar)
  end
end

# app/controllers/food_requests_controller.rb
class FoodRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food_post, only: [:new, :create]
  before_action :set_food_request, only: [:show, :accept, :reject, :cancel]
  before_action :check_ownership, only: [:accept, :reject]
  before_action :check_requester, only: [:cancel]
  
  def index
    @food_requests = current_user.food_requests.includes(:food_post)
  end
  
  def show
  end
  
  def new
    # 既にリクエスト済みかチェック
    if current_user.food_requests.exists?(food_post_id: @food_post.id)
      redirect_to @food_post, alert: "既にこの食品にリクエストを送っています"
      return
    end
    
    # 自分の投稿にはリクエストできない
    if @food_post.user_id == current_user.id
      redirect_to @food_post, alert: "自分の投稿にはリクエストできません"
      return
    end
    
    @food_request = FoodRequest.new
  end
  
  def create
    @food_request = current_user.food_requests.new(food_request_params)
    @food_request.food_post = @food_post
    
    if @food_request.save
      # 通知を送る処理などをここに追加
      redirect_to @food_post, notice: "リクエストを送信しました"
    else
      # リダイレクトに変更（render :newではなく）
      flash[:alert] = "入力内容に問題があります：" + @food_request.errors.full_messages.join(", ")
      redirect_to new_food_post_food_request_path(@food_post)
    end
  end
  
  def accept
    @food_request.update(status: "accepted")
    # 他の保留中リクエストを拒否
    @food_request.food_post.food_requests.pending.where.not(id: @food_request.id).update_all(status: "rejected", rejection_reason: "他のリクエストが承認されました")
    # 食品の状態を「reserved」に変更
    @food_request.food_post.update(status: "reserved")
    
    # 通知を送る処理などをここに追加
    
    redirect_to @food_request, notice: "リクエストを承認しました"
  end
  
  def reject
    @food_request.update(food_request_params.merge(status: "rejected"))
    
    # 通知を送る処理などをここに追加
    
    redirect_to @food_request, notice: "リクエストを拒否しました"
  end
  
  def cancel
    @food_request.update(status: "canceled")
    
    # 通知を送る処理などをここに追加
    
    redirect_to @food_request, notice: "リクエストをキャンセルしました"
  end
  
  private
  
  def set_food_post
    @food_post = FoodPost.find(params[:food_post_id])
  end
  
  def set_food_request
    @food_request = FoodRequest.find(params[:id])
  end
  
  def food_request_params
    params.require(:food_request).permit(:message, :pickup_time, :rejection_reason)
  end
  
  def check_ownership
    unless @food_request.food_post.user_id == current_user.id
      redirect_to root_path, alert: "権限がありません"
    end
  end
  
  def check_requester
    unless @food_request.user_id == current_user.id
      redirect_to root_path, alert: "権限がありません"
    end
  end
end
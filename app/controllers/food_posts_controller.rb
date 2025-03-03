class FoodPostsController < ApplicationController
  # ログインが必要なアクションを指定（一覧表示と詳細表示は閲覧可）
  # before_action :require_login, except: %i[index show]

  # 詳細表示、編集、更新、削除アクションの前に対象の投稿を取得
  before_action :set_food_post, only: %i[show edit update destroy]

  # 編集、更新、削除アクションの前に投稿者本人かどうかを確認
  before_action :authorize_user!, only: %i[edit update destroy]

  # 投稿一覧を表示
  def index
    # Ransackを使用した検索クエリの設定
    @q = FoodPost.ransack(params[:q])

    # 検索結果を取得し、以下の条件で絞り込み
    @food_posts = @q.result(distinct: true)
                    .available           # ステータスが「利用可能」のみ表示
                    .includes(:user)     # N+1問題を回避するためユーザー情報を事前読込
                    .order(expiration_date: :asc) # 賞味期限が近い順にソート
                    .paginate(page: params[:page], per_page: 10) # ページネーション（10件/ページ）
  end

  # 投稿の詳細を表示
 

  # 新規投稿フォームを表示
  def new
    # 現在のログインユーザーに紐づく新しい投稿オブジェクトを作成
    @food_post = current_user.food_posts.new
  end

  # 新規投稿を保存
  def create
    # フォームから送信されたパラメータで投稿オブジェクトを作成
    @food_post = current_user.food_posts.new(food_post_params)

    # 保存に成功した場合
    if @food_post.save
      # 詳細ページにリダイレクトし、成功メッセージを表示
      redirect_to @food_post, notice: '食品を投稿しました'
    else
      # バリデーションエラー時は入力フォームを再表示
      render :new
    end
  end

  # 投稿編集フォームを表示
  def edit
    # authorize_user!で投稿者本人かどうかのチェック済み
  end

  # 投稿内容を更新
  def update
    # フォームから送信されたパラメータで投稿を更新
    if @food_post.update(food_post_params)
      # 更新成功時は詳細ページにリダイレクトし成功メッセージを表示
      redirect_to @food_post, notice: '投稿を更新しました'
    else
      # バリデーションエラー時は編集フォームを再表示
      render :edit
    end
  end

  # 投稿を削除
  def destroy
    # 投稿を削除
    @food_post.destroy
    # 削除後は投稿一覧ページにリダイレクトし、成功メッセージを表示
    redirect_to food_posts_path, notice: '投稿を削除しました'
  end

  private

  # URLパラメータから投稿を取得するヘルパーメソッド
  def set_food_post
    # 指定されたIDの投稿を取得
    @food_post = FoodPost.find(params[:id])
  # 投稿が見つからない場合の例外処理
  rescue ActiveRecord::RecordNotFound
    # 投稿一覧ページにリダイレクトしエラーメッセージを表示
    redirect_to food_posts_path, alert: '投稿が見つかりません'
  end

  # 投稿者本人かどうかを確認するヘルパーメソッド
  def authorize_user!
    # 現在のユーザーが投稿者でない場合
    return if @food_post.user == current_user

    # 投稿一覧ページにリダイレクトし権限エラーメッセージを表示
    redirect_to food_posts_path, alert: '権限がありません'
  end

  # Strong Parametersによるセキュアなパラメータ取得
  def food_post_params
    # フォームから送信された値のうち、許可された属性のみを取得
    params.require(:food_post).permit(
      :title,            # タイトル
      :description,      # 説明
      :quantity,         # 数量
      :unit,             # 単位
      :expiration_date,  # 賞味期限
      :pickup_location,  # 受け取り場所
      :pickup_time_slot, # 受け取り時間帯
      :image             # 画像
    )
  end
end

# app/models/food_request.rb
class FoodRequest < ApplicationRecord
    # リレーションシップの定義
    belongs_to :user     # リクエストを送信したユーザーとの関連付け
    belongs_to :food_post  # リクエスト対象の食品投稿との関連付け
    
    # バリデーション: ステータスは必須で、指定された値のいずれかであることを検証
    # %w() は文字列の配列を作成するショートカット構文
    validates :status, presence: true, inclusion: { in: %w(pending accepted rejected canceled) }
    
    # バリデーション: 同一ユーザーが同一食品に複数回リクエストすることを防止
    # scope: オプションで、user_id と food_post_id の組み合わせでの一意性を強制
    validates :user_id, uniqueness: { scope: :food_post_id, message: "既にこの食品にリクエストを送っています" }
    
    # カスタムバリデーション: 期限切れの食品にはリクエストできないことを検証
    validate :food_post_not_expired
    
    # カスタムバリデーション: 「available」ステータスの食品のみリクエスト可能
    # on: :create は、新規作成時のみこのバリデーションを適用することを指定
    validate :food_post_available, on: :create
    
    # クエリ用スコープ定義: ステータスごとのレコード取得を容易にする
    scope :pending, -> { where(status: "pending") }     # 保留中のリクエスト
    scope :accepted, -> { where(status: "accepted") }   # 承認済みのリクエスト
    scope :rejected, -> { where(status: "rejected") }   # 拒否済みのリクエスト
    scope :canceled, -> { where(status: "canceled") }   # キャンセル済みのリクエスト
    
    private
    
    # カスタムバリデーションメソッド: 食品の期限が現在日より後であることを確認
    def food_post_not_expired
      if food_post.expiration_date < Date.today
        errors.add(:food_post, "この食品は既に期限切れです")
      end
    end
    
    # カスタムバリデーションメソッド: 食品が「available」ステータスであることを確認
    def food_post_available
      unless food_post.status == "available"
        errors.add(:food_post, "この食品は既に取引中か譲渡済みです")
      end
    end
  end
  
  
class FoodPost < ApplicationRecord
  belongs_to :user
  # 投稿に対するリクエストを取得できるようにする
  # user.rb
  has_many :requests, dependent: :destroy

  # 投稿にリクエストしたユーザーを取得できるようにする
  # through: :requestsで中間テーブルとしてrequestsを指定
  # source: :userで関連するモデルを指定
  has_many :requesting_users, through: :requests, source: :user
  mount_uploader :image, ImageUploader

  # バリデーション
  validates :title, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true
  validates :expiration_date, presence: true
  validates :pickup_location, presence: true
  validates :pickup_time_slot, presence: true
  validates :image, presence: true
  validates :reason, length: { maximum: 255 }, allow_blank: true

  # ステータス管理
  enum status: {
    available: 'available',
    reserved: 'reserved',
    completed: 'completed'
  }

  # カスタムバリデーション
  validate :expiration_date_cannot_be_in_past

  # ransack用の検索可能属性
  def self.ransackable_attributes(_auth_object = nil)
    %w[title pickup_location expiration_date status] # statusを追加
  end

  # ransack用の検索可能な関連付け
  def self.ransackable_associations(_auth_object = nil)
    ['user']
  end

  private

  def expiration_date_cannot_be_in_past
    return unless expiration_date.present? && expiration_date < Date.today

    errors.add(:expiration_date, 'は今日以降の日付を選択してください')
  end
end

class FoodPost < ApplicationRecord
  belongs_to :user
  has_many :food_requests, dependent: :destroy
  has_many :requesting_users, through: :food_requests, source: :user
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
    %w[title pickup_location expiration_date status]
  end

  # ransack用の検索可能な関連付け
  def self.ransackable_associations(_auth_object = nil)
    ['user']
  end

  # 承認済みリクエストを取得するメソッド
  def accepted_request
    food_requests.accepted.first
  end

  # 保留中のリクエストを取得するメソッド
  def pending_requests
    food_requests.pending
  end

  private

  def expiration_date_cannot_be_in_past
    return unless expiration_date.present? && expiration_date < Date.today
    errors.add(:expiration_date, 'は今日以降の日付を選択してください')
  end
end
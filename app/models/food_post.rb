class FoodPost < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit, presence: true
  validates :expiration_date, presence: true
  validates :pickup_location, presence: true
  validates :status, presence: true, inclusion: { in: %w[available reserved claimed] }

  has_one_attached :image # 画像アップロードを考慮する場合
end

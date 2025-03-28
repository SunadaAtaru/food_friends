# frozen_string_literal: true

# User model for managing user accounts and profiles
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable # この行を追加

  # ユーザー名は必須、一意性、最小3文字、最大30文字
  validates :username, presence: true,
                       uniqueness: true,
                       length: { minimum: 3, maximum: 30 }

  # 自己紹介文は任意、最大500文字まで
  validates :introduction, length: { maximum: 500 }, allow_blank: true

  # 住所は任意、最大100文字まで
  validates :address, length: { maximum: 100 }, allow_blank: true

  # 連絡先は任意、最大50文字まで
  validates :contact, length: { maximum: 50 }, allow_blank: true

  # アバターアップローダーをマウント
  mount_uploader :avatar, AvatarUploader

  has_many :food_posts, dependent: :destroy # ユーザー削除時に関連する投稿も削除
  
  # 開発環境のみ、作成時に自動的に確認する
  after_create :auto_confirm, if: -> { Rails.env.development? }

  private

  def auto_confirm
    self.update_column(:confirmed_at, Time.current)
  end
end
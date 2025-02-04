# frozen_string_literal: true

# User model for managing user accounts and profiles
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
end

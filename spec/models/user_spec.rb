# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    # テスト用のユーザーを作成
    let(:user) { User.create(email: 'test@example.com', password: 'password', username: 'testuser') }

    # 有効な属性がある場合、バリデーションが通ることをテスト
    it 'すべての属性が有効な場合、ユーザーは有効であること' do
      expect(user).to be_valid
    end

    # ユーザー名がない場合、バリデーションが失敗することをテスト
    it 'ユーザー名がない場合、無効であること' do
      user.username = nil
      expect(user).not_to be_valid
    end

    # 重複したユーザー名が存在する場合、バリデーションが失敗することをテスト
    it '重複したユーザー名が存在する場合、無効であること' do
      duplicate_user = user.dup
      duplicate_user.email = 'another@example.com'
      expect(duplicate_user).not_to be_valid
    end

    # ユーザー名が3文字未満の場合、バリデーションが失敗することをテスト
    it 'ユーザー名が3文字未満の場合、無効であること' do
      user.username = 'ab'
      expect(user).not_to be_valid
    end

    # ユーザー名が30文字を超える場合、バリデーションが失敗することをテスト
    it 'ユーザー名が30文字を超える場合、無効であること' do
      user.username = 'a' * 31
      expect(user).not_to be_valid
    end
  end
end


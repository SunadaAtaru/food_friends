# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーションのテスト' do
    # テスト用のユーザーを作成

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

  describe 'avatarのテスト' do
    it 'avatarを添付できること' do
      user = User.create!(
        email: 'test@example.com',
        password: 'password',
        username: 'testuser'
      )

      file_path = Rails.root.join('spec', 'fixtures', 'test_image.jpg')
      user.avatar = File.open(file_path)

      if user.valid?
        puts 'Validation passed'
      else
        puts "Validation failed: #{user.errors.full_messages}"
      end

      expect(user.save).to be true
      expect(user.avatar.file.exists?).to be true
    end
  end

  describe 'アカウント管理機能' do
    let(:user) { User.create(email: 'test@example.com', password: 'password', username: 'testuser') }

    it 'パスワードを変更できること' do
      expect(user.update(password: 'newpassword', password_confirmation: 'newpassword')).to be true
    end

    it '現在のパスワードなしではメールアドレスを変更できないこと' do
      expect(user.update_with_password(
               email: 'new@example.com',
               current_password: nil
             )).to be false
    end

    it '現在のパスワードがあれば、メールアドレスを変更できること' do
      expect(
        user.update_with_password(
          email: 'new@example.com',
          current_password: 'password'
        )
      ).to be true
    end
  end

  describe 'パスワードリセット' do
    let(:user) { create(:user) } # ここに追加

    before do
      ActionMailer::Base.deliveries.clear
    end

    it 'パスワードリセットトークンを生成できる' do
      expect do
        user.send_reset_password_instructions
      end.to change { user.reset_password_token }.from(nil)
    end

    it 'パスワードリセット用のメールを送信できる' do
      expect do
        user.send_reset_password_instructions
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
  # spec/models/user_spec.rb に追加
  describe 'メール確認機能' do
    let(:user) { create(:user, confirmed_at: nil) }

    it '確認前のユーザーは未確認状態である' do
      expect(user.confirmed?).to be_falsey
    end

    it '確認後のユーザーは確認済み状態になる' do
      user.confirm
      expect(user.confirmed?).to be_truthy
    end

    it 'メールアドレス変更時に確認が必要' do
      confirmed_user = create(:user, confirmed_at: Time.current)
      confirmed_user.email = 'new@example.com'
      confirmed_user.save
      expect(confirmed_user.unconfirmed_email).to eq('new@example.com')
    end
  end
end

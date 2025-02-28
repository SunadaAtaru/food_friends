require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーションのテスト' do
    it 'すべての属性が有効な場合、ユーザーは有効であること' do
      expect(user).to be_valid
    end

    it 'ユーザー名がない場合、無効であること' do
      user.username = nil
      expect(user).not_to be_valid
    end

    it '重複したユーザー名が存在する場合、無効であること' do
      duplicate_user = user.dup
      duplicate_user.email = 'another@example.com'
      expect(duplicate_user).not_to be_valid
    end

    it 'ユーザー名が3文字未満の場合、無効であること' do
      user.username = 'ab'
      expect(user).not_to be_valid
    end

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
    let(:user) { create(:user) }

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

  describe '管理者機能' do
    let!(:admin) { create(:user, admin: true) }
    let!(:user) { create(:user, admin: false) }

    it 'デフォルトで一般ユーザーは管理者ではない' do
      new_user = create(:user)
      expect(new_user.admin?).to be false
    end

    it '管理者フラグを持つユーザーは管理者である' do
      expect(admin.admin?).to be true
    end

    it '一般ユーザーは管理者ではない' do
      expect(user.admin?).to be false
    end

    it '一般ユーザーを管理者に変更できる' do
      user.update(admin: true)
      expect(user.reload.admin?).to be true
    end

    it '管理者を一般ユーザーに変更できる' do
      admin.update(admin: false)
      expect(admin.reload.admin?).to be false
    end

    context '管理者スコープのテスト' do
      it '管理者のみ取得できる' do
        expect(User.where(admin: true)).to include(admin)
        expect(User.where(admin: true)).not_to include(user)
      end
    end
  end

  describe 'ユーザー削除機能' do
    let!(:admin) { create(:user, admin: true) }
    let!(:user) { create(:user, admin: false) }

    it '一般ユーザーを削除できる' do
      expect { user.destroy }.to change(User, :count).by(-1)
    end

    it '管理者を削除できる' do
      expect { admin.destroy }.to change(User, :count).by(-1)
    end

    # context '関連データの削除' do
    #   let!(:food_post) { create(:food_post, user: user) }

    #   it 'ユーザーを削除すると関連する投稿も削除される' do
    #     expect { user.destroy }.to change(FoodPost, :count).by(-1)
    #   end
    # end
  end
end

# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  # ユーザーが有効な属性を持っている場合、バリデーションが通ることをテストする
  it "すべての属性が有効な場合、ユーザーは有効であること" do
    user = User.new(
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
    expect(user).to be_valid
  end

  # ユーザーがメールアドレスを持っていない場合、バリデーションが失敗することをテストする
  it "メールアドレスがない場合、ユーザーは無効であること" do
    user = User.new(email: nil)
    expect(user).not_to be_valid
  end
end

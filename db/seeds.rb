require 'faker'

# 既存のユーザーを削除
User.destroy_all

# 管理者を1人作成（Userモデルで admin: true として作成）
User.create!(
  username: '管理者ユーザー',
  email: 'admin@example.com',
  password: 'adminpass',
  password_confirmation: 'adminpass',
  admin: true
  confirmed_at: Time.current  # これが重要！
)

puts '管理者ユーザーを作成しました'

# 一般ユーザーを10人作成
10.times do
  User.create!(
    username: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password',
    admin: false
    confirmed_at: Time.current  # すべてのユーザーを確認済みに
  )
end

puts '一般ユーザーを10人作成しました'

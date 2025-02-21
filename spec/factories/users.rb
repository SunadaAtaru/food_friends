# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    sequence(:username) { |n| "testuser#{n}" }
    password { 'password' }
    confirmed_at { Time.current }

    trait :unconfirmed do
      confirmed_at { nil }
      # メール送信をスキップするオプションを追加
      after(:build) do |user|
        user.skip_confirmation_notification!
      end
    end
  end
end

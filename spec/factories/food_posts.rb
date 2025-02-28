FactoryBot.define do
  factory :food_post do
    title { "テスト投稿" }
    description { "これはテストの投稿です" }
    quantity { 3 }
    unit { "個" }
    expiration_date { Date.today + 7.days }
    pickup_location { "東京都新宿区" }
    status { "available" }
    association :user
  end
end

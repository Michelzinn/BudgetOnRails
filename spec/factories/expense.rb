FactoryBot.define do
  factory :expense do
    association :budget
    association :category
    association :user
    amount_cents { rand(100..10000) } # $1.00 to $100.00
    description { Faker::Lorem.sentence(word_count: 3) }
    spent_at { Time.current }

    trait :food_expense do
      description { [ "Grocery shopping", "Restaurant dinner", "Coffee", "Lunch" ].sample }
      amount_cents { rand(500..5000) }
    end

    trait :home_expense do
      description { [ "Rent", "Utilities", "Internet", "Home supplies" ].sample }
      amount_cents { rand(5000..100000) }
    end

    trait :entertainment_expense do
      description { [ "Movie tickets", "Video game", "Concert", "Streaming service" ].sample }
      amount_cents { rand(1000..6000) }
    end
  end
end

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    trait :with_budget do
      after(:create) do |user|
        create(:budget, user: user)
      end
    end

    trait :with_full_setup do
      after(:create) do |user|
        budget = create(:budget, user: user, total_amount_cents: 200000) # $2000

        # Create categories
        food = create(:category, name: "Food", user: user, budget: budget)
        home = create(:category, name: "Home", user: user, budget: budget)
        games = create(:category, name: "Video Games", user: user, budget: budget)

        # Create allocations
        create(:budget_allocation, budget: budget, category: food, amount_cents_allocated: 50000)
        create(:budget_allocation, budget: budget, category: home, amount_cents_allocated: 50000)
        create(:budget_allocation, budget: budget, category: games, amount_cents_allocated: 50000)
      end
    end
  end
end

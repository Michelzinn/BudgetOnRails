FactoryBot.define do
  factory :budget do
    association :user
    total_amount_cents { 100000 } # $1000.00
    date { Date.current }

    trait :with_allocations do
      after(:create) do |budget|
        food = create(:category, name: "Food", user: budget.user, budget: budget)
        home = create(:category, name: "Home", user: budget.user, budget: budget)
        entertainment = create(:category, name: "Entertainment", user: budget.user, budget: budget)

        create(:budget_allocation, budget: budget, category: food, amount_cents_allocated: 40000)
        create(:budget_allocation, budget: budget, category: home, amount_cents_allocated: 40000)
        create(:budget_allocation, budget: budget, category: entertainment, amount_cents_allocated: 20000)
      end
    end

    trait :fully_allocated do
      total_amount_cents { 100000 }

      after(:create) do |budget|
        food = create(:category, name: "Food", user: budget.user, budget: budget)
        home = create(:category, name: "Home", user: budget.user, budget: budget)

        create(:budget_allocation, budget: budget, category: food, amount_cents_allocated: 50000)
        create(:budget_allocation, budget: budget, category: home, amount_cents_allocated: 50000)
      end
    end

    trait :over_budget do
      total_amount_cents { 100000 }

      after(:create) do |budget|
        food = create(:category, name: "Food", user: budget.user, budget: budget)

        create(:budget_allocation, budget: budget, category: food, amount_cents_allocated: 120000)
      end
    end
  end
end

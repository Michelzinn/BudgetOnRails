FactoryBot.define do
  factory :budget_allocation do
    association :budget
    association :category
    amount_cents_allocated { 10000 } # $100.00 default

    trait :small do
      amount_cents_allocated { 5000 } # $50.00
    end

    trait :medium do
      amount_cents_allocated { 25000 } # $250.00
    end

    trait :large do
      amount_cents_allocated { 50000 } # $500.00
    end

    # Ensure category belongs to same user and budget
    after(:build) do |allocation|
      if allocation.budget && allocation.category
        allocation.category.user ||= allocation.budget.user
        allocation.category.budget ||= allocation.budget
      end
    end
  end
end

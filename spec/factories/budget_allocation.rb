FactoryBot.define do
  factory :budget_allocation do
    association :budget
    association :category
    amount_cents_allocated { 10000 }
    created_at { Time.now }
    updated_at { Time.now }
  end
end

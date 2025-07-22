FactoryBot.define do
  factory :category do
    association :user
    association :budget
    sequence(:name) { |n| "Category #{n}" }

    trait :food do
      name { "Food" }
    end

    trait :home do
      name { "Home" }
    end

    trait :entertainment do
      name { "Entertainment" }
    end

    trait :with_allocation do
      after(:create) do |category|
        create(:budget_allocation,
               budget: category.budget,
               category: category,
               amount_cents_allocated: 50000)
      end
    end

    trait :with_expenses do
      after(:create) do |category|
        3.times do
          create(:expense,
                 user: category.user,
                 budget: category.budget,
                 category: category,
                 amount_cents: rand(1000..10000))
        end
      end
    end
  end
end

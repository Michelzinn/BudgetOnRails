FactoryBot.define do
  factory :expense do
  association :budget
  association :category
  association :user
  amount { '123' }
  description { "Expense" }
  spent_at { Time.zone.now }
  end
end

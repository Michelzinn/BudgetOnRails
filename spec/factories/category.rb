FactoryBot.define do
  factory :category do
    association :user
    association :budget
    name { "Sample Category" }
  end
end

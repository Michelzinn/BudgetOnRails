FactoryBot.define do
  factory :budget do
    association :user
    total_amount_cents { 1000.00 }
    date { Date.today }
  end
end

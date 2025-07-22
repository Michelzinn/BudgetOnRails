# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database..."

# Create a test user
user = User.find_or_create_by!(email: "test@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
end
puts "✅ User created: #{user.email}"

# Create a budget for the current month
budget = Budget.find_or_create_by!(
  user: user,
  date: Date.current.beginning_of_month
) do |b|
  b.total_amount_cents = 300000 # $3,000.00
end
puts "✅ Budget created for: #{budget.date.strftime('%B %Y')}"

# Create categories with English names
categories = {
  "Food" => 80000,           # $800.00
  "Housing" => 120000,       # $1,200.00
  "Transportation" => 40000, # $400.00
  "Entertainment" => 30000,  # $300.00
  "Healthcare" => 20000,     # $200.00
  "Other" => 10000          # $100.00
}

categories.each do |name, allocation|
  category = Category.find_or_create_by!(
    name: name,
    user: user,
    budget: budget
  )

  BudgetAllocation.find_or_create_by!(
    budget: budget,
    category: category
  ) do |ba|
    ba.amount_cents_allocated = allocation
  end

  puts "✅ Category '#{name}' created with allocation: #{ActionController::Base.helpers.number_to_currency(allocation / 100.0, unit: 'R$ ', separator: ',', delimiter: '.')}"
end

# Create some expenses for the current month
expenses_data = [
  # Food expenses
  { category: "Food", description: "Grocery Store", amount: 25000, days_ago: 2 },
  { category: "Food", description: "Bakery", amount: 1500, days_ago: 1 },
  { category: "Food", description: "Japanese Restaurant", amount: 8000, days_ago: 3 },
  { category: "Food", description: "Food Delivery", amount: 4500, days_ago: 0 },
  { category: "Food", description: "Farmers Market", amount: 12000, days_ago: 5 },

  # Housing expenses
  { category: "Housing", description: "Rent", amount: 100000, days_ago: 5 },
  { category: "Housing", description: "Electricity Bill", amount: 15000, days_ago: 3 },
  { category: "Housing", description: "Internet", amount: 10000, days_ago: 2 },

  # Transportation expenses
  { category: "Transportation", description: "Uber", amount: 3500, days_ago: 0 },
  { category: "Transportation", description: "Gas", amount: 25000, days_ago: 4 },
  { category: "Transportation", description: "Parking", amount: 2000, days_ago: 1 },

  # Entertainment expenses
  { category: "Entertainment", description: "Movie Theater", amount: 4500, days_ago: 2 },
  { category: "Entertainment", description: "Netflix", amount: 3990, days_ago: 10 },
  { category: "Entertainment", description: "Spotify", amount: 1990, days_ago: 10 },

  # Healthcare expenses
  { category: "Healthcare", description: "Pharmacy", amount: 8500, days_ago: 1 },
  { category: "Healthcare", description: "Gym Membership", amount: 12000, days_ago: 5 }
]

expenses_data.each do |expense_data|
  category = Category.find_by!(name: expense_data[:category])

  Expense.create!(
    user: user,
    budget: budget,
    category: category,
    description: expense_data[:description],
    amount_cents: expense_data[:amount],
    spent_at: expense_data[:days_ago].days.ago
  )
end

puts "✅ #{expenses_data.count} expenses created"

# Summary
puts "\n📊 Database seeded successfully!"
puts "   User: #{user.email} (password: password123)"
puts "   Total budget: #{ActionController::Base.helpers.number_to_currency(budget.total_amount_cents / 100.0, unit: 'R$ ', separator: ',', delimiter: '.')}"
puts "   Categories: #{budget.categories.count}"
puts "   Total expenses: #{budget.expenses.count}"
puts "\n🚀 You can now login and view your budget!"

require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:budget) }
    it { should belong_to(:category) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount_cents) }
    it { should validate_numericality_of(:amount_cents).is_greater_than(0) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:spent_at) }
  end

  describe 'factory' do
    it 'creates a valid expense' do
      expect(build(:expense)).to be_valid
    end

    it 'creates expense with consistent associations' do
      user = create(:user)
      budget = create(:budget, user: user)
      category = create(:category, user: user, budget: budget)
      expense = create(:expense, user: user, budget: budget, category: category)

      expect(expense.user).to eq(user)
      expect(expense.budget).to eq(budget)
      expect(expense.category).to eq(category)
      expect(expense.budget.user).to eq(user)
      expect(expense.category.user).to eq(user)
      expect(expense.category.budget).to eq(budget)
    end

    it 'creates food expense using trait' do
      expense = create(:expense, :food_expense)

      expect(expense.description).to be_in([ "Grocery shopping", "Restaurant dinner", "Coffee", "Lunch" ])
      expect(expense.amount_cents).to be_between(500, 5000)
    end

    it 'creates home expense using trait' do
      expense = create(:expense, :home_expense)

      expect(expense.description).to be_in([ "Rent", "Utilities", "Internet", "Home supplies" ])
      expect(expense.amount_cents).to be_between(5000, 100000)
    end

    it 'creates entertainment expense using trait' do
      expense = create(:expense, :entertainment_expense)

      expect(expense.description).to be_in([ "Movie tickets", "Video game", "Concert", "Streaming service" ])
      expect(expense.amount_cents).to be_between(1000, 6000)
    end
  end

  describe 'data integrity' do
    it 'ensures expense amount is positive' do
      expense = build(:expense, amount_cents: 0)

      expect(expense).not_to be_valid
      expect(expense.errors[:amount_cents]).to include("must be greater than 0")
    end

    it 'requires all fields to be present' do
      expense = Expense.new

      expect(expense).not_to be_valid
      expect(expense.errors[:user]).to include("must exist")
      expect(expense.errors[:budget]).to include("must exist")
      expect(expense.errors[:category]).to include("must exist")
      expect(expense.errors[:amount_cents]).to include("can't be blank")
      expect(expense.errors[:description]).to include("can't be blank")
      expect(expense.errors[:spent_at]).to include("can't be blank")
    end
  end
end

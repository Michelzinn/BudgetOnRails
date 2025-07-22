require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:budget) }
    it { should have_many(:budget_allocations).dependent(:destroy) }
    it { should have_many(:expenses).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }

    describe 'name uniqueness' do
      let(:user) { create(:user) }
      let(:budget) { create(:budget, user: user) }
      let!(:category) { create(:category, name: "Food", user: user, budget: budget) }

      it 'validates uniqueness of name within same budget' do
        duplicate_category = build(:category, name: "Food", user: user, budget: budget)

        expect(duplicate_category).not_to be_valid
        expect(duplicate_category.errors[:name]).to include("already exists for this budget")
      end

      it 'allows same name in different budgets' do
        other_budget = create(:budget, user: user)
        different_budget_category = build(:category, name: "Food", user: user, budget: other_budget)

        expect(different_budget_category).to be_valid
      end
    end
  end

  describe 'instance methods' do
    let(:user) { create(:user) }
    let(:budget) { create(:budget, user: user) }
    let(:category) { create(:category, user: user, budget: budget) }

    describe '#total_expenses' do
      it 'returns sum of all expenses in the category' do
        create(:expense, user: user, budget: budget, category: category, amount_cents: 5000)
        create(:expense, user: user, budget: budget, category: category, amount_cents: 3000)

        expect(category.total_expenses).to eq(8000)
      end

      it 'returns 0 when no expenses exist' do
        expect(category.total_expenses).to eq(0)
      end
    end

    describe '#allocation_amount' do
      it 'returns the allocated amount for this category in its budget' do
        create(:budget_allocation, budget: budget, category: category, amount_cents_allocated: 50000)

        expect(category.allocation_amount).to eq(50000)
      end

      it 'returns 0 when no allocation exists' do
        expect(category.allocation_amount).to eq(0)
      end

      it 'returns sum of multiple allocations if they exist' do
        create(:budget_allocation, budget: budget, category: category, amount_cents_allocated: 30000)
        create(:budget_allocation, budget: budget, category: category, amount_cents_allocated: 20000)

        expect(category.allocation_amount).to eq(50000)
      end
    end

    describe '#remaining_allocation' do
      it 'returns difference between allocation and expenses' do
        create(:budget_allocation, budget: budget, category: category, amount_cents_allocated: 50000)
        create(:expense, user: user, budget: budget, category: category, amount_cents: 15000)

        expect(category.remaining_allocation).to eq(35000)
      end

      it 'returns negative value when over budget' do
        create(:budget_allocation, budget: budget, category: category, amount_cents_allocated: 10000)
        create(:expense, user: user, budget: budget, category: category, amount_cents: 15000)

        expect(category.remaining_allocation).to eq(-5000)
      end
    end

    describe '#percentage_used' do
      it 'returns percentage of allocation used' do
        create(:budget_allocation, budget: budget, category: category, amount_cents_allocated: 50000)
        create(:expense, user: user, budget: budget, category: category, amount_cents: 12500)

        expect(category.percentage_used).to eq(25.0)
      end

      it 'returns 0 when allocation_amount is 0' do
        expect(category.percentage_used).to eq(0)
      end

      it 'can return over 100% when over budget' do
        create(:budget_allocation, budget: budget, category: category, amount_cents_allocated: 10000)
        create(:expense, user: user, budget: budget, category: category, amount_cents: 15000)

        expect(category.percentage_used).to eq(150.0)
      end
    end

    describe '#over_budget?' do
      it 'returns true when expenses exceed allocation' do
        create(:budget_allocation, budget: budget, category: category, amount_cents_allocated: 10000)
        create(:expense, user: user, budget: budget, category: category, amount_cents: 15000)

        expect(category.over_budget?).to be true
      end

      it 'returns false when within budget' do
        create(:budget_allocation, budget: budget, category: category, amount_cents_allocated: 50000)
        create(:expense, user: user, budget: budget, category: category, amount_cents: 30000)

        expect(category.over_budget?).to be false
      end
    end
  end

  describe 'factory' do
    it 'creates a valid category' do
      expect(build(:category)).to be_valid
    end

    it 'creates category with allocation using trait' do
      category = create(:category, :with_allocation)

      expect(category.budget_allocations.count).to eq(1)
      expect(category.allocation_amount).to eq(50000)
    end

    it 'creates category with expenses using trait' do
      category = create(:category, :with_expenses)

      expect(category.expenses.count).to eq(3)
      expect(category.total_expenses).to be > 0
    end
  end
end

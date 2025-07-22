require 'rails_helper'

RSpec.describe BudgetAllocation, type: :model do
  describe 'associations' do
    it { should belong_to(:budget) }
    it { should belong_to(:category) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount_cents_allocated) }
    it { should validate_numericality_of(:amount_cents_allocated).is_greater_than_or_equal_to(0) }
  end

  describe 'instance methods' do
    let(:user) { create(:user) }
    let(:budget) { create(:budget, user: user, total_amount_cents: 100000) }
    let(:category) { create(:category, user: user, budget: budget) }
    let(:budget_allocation) { create(:budget_allocation, budget: budget, category: category, amount_cents_allocated: 25000) }

    describe '#percentage_of_budget' do
      it 'returns percentage of total budget' do
        expect(budget_allocation.percentage_of_budget).to eq(25.0)
      end

      it 'returns 0 when budget total is 0' do
        budget.update(total_amount_cents: 0)

        expect(budget_allocation.percentage_of_budget).to eq(0)
      end

      it 'handles decimal percentages correctly' do
        budget_allocation.update(amount_cents_allocated: 33333)

        expect(budget_allocation.percentage_of_budget).to eq(33.33)
      end
    end
  end

  describe 'factory' do
    it 'creates a valid budget allocation' do
      expect(build(:budget_allocation)).to be_valid
    end

    it 'creates small allocation using trait' do
      allocation = create(:budget_allocation, :small)

      expect(allocation.amount_cents_allocated).to eq(5000)
    end

    it 'creates medium allocation using trait' do
      allocation = create(:budget_allocation, :medium)

      expect(allocation.amount_cents_allocated).to eq(25000)
    end

    it 'creates large allocation using trait' do
      allocation = create(:budget_allocation, :large)

      expect(allocation.amount_cents_allocated).to eq(50000)
    end

    it 'ensures category belongs to same budget' do
      user = create(:user)
      budget = create(:budget, user: user)
      category = create(:category, user: user, budget: budget)
      allocation = create(:budget_allocation, budget: budget, category: category)

      expect(allocation.category.budget).to eq(allocation.budget)
      expect(allocation.category.user).to eq(allocation.budget.user)
    end
  end
end

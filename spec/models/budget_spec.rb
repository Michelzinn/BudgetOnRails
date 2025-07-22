require 'rails_helper'

RSpec.describe Budget, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:budget_allocations).dependent(:destroy) }
    it { should have_many(:categories).dependent(:destroy) }
    it { should have_many(:expenses).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:total_amount_cents) }
    it { should validate_numericality_of(:total_amount_cents).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:date) }
  end

  describe 'instance methods' do
    let(:user) { create(:user) }
    let(:budget) { create(:budget, user: user, total_amount_cents: 200000) }
    let(:category1) { create(:category, user: user, budget: budget, name: "Food") }
    let(:category2) { create(:category, user: user, budget: budget, name: "Home") }

    describe '#allocated_amount' do
      it 'returns sum of all budget allocations' do
        create(:budget_allocation, budget: budget, category: category1, amount_cents_allocated: 50000)
        create(:budget_allocation, budget: budget, category: category2, amount_cents_allocated: 70000)

        expect(budget.allocated_amount).to eq(120000)
      end

      it 'returns 0 when no allocations exist' do
        expect(budget.allocated_amount).to eq(0)
      end
    end

    describe '#remaining_amount' do
      it 'returns difference between total and allocated amounts' do
        create(:budget_allocation, budget: budget, category: category1, amount_cents_allocated: 50000)

        expect(budget.remaining_amount).to eq(150000)
      end

      it 'returns negative value when over-allocated' do
        create(:budget_allocation, budget: budget, category: category1, amount_cents_allocated: 250000)

        expect(budget.remaining_amount).to eq(-50000)
      end
    end

    describe '#percentage_allocated' do
      it 'returns percentage of budget allocated' do
        create(:budget_allocation, budget: budget, category: category1, amount_cents_allocated: 50000)

        expect(budget.percentage_allocated).to eq(25.0)
      end

      it 'returns 0 when total_amount_cents is 0' do
        budget.update(total_amount_cents: 0)

        expect(budget.percentage_allocated).to eq(0)
      end

      it 'handles over-allocation correctly' do
        create(:budget_allocation, budget: budget, category: category1, amount_cents_allocated: 250000)

        expect(budget.percentage_allocated).to eq(125.0)
      end
    end

    describe '#fully_allocated?' do
      it 'returns true when remaining amount is 0' do
        create(:budget_allocation, budget: budget, category: category1, amount_cents_allocated: 200000)

        expect(budget.fully_allocated?).to be true
      end

      it 'returns false when there is remaining amount' do
        create(:budget_allocation, budget: budget, category: category1, amount_cents_allocated: 100000)

        expect(budget.fully_allocated?).to be false
      end
    end

    describe '#over_allocated?' do
      it 'returns true when allocated more than total' do
        create(:budget_allocation, budget: budget, category: category1, amount_cents_allocated: 250000)

        expect(budget.over_allocated?).to be true
      end

      it 'returns false when allocated less than or equal to total' do
        create(:budget_allocation, budget: budget, category: category1, amount_cents_allocated: 100000)

        expect(budget.over_allocated?).to be false
      end
    end
  end

  describe 'factory' do
    it 'creates a valid budget' do
      expect(build(:budget)).to be_valid
    end

    it 'creates budget with allocations using trait' do
      budget = create(:budget, :with_allocations)

      expect(budget.budget_allocations.count).to eq(3)
      expect(budget.categories.count).to eq(3)
    end

    it 'creates fully allocated budget using trait' do
      budget = create(:budget, :fully_allocated)

      expect(budget.fully_allocated?).to be true
    end

    it 'creates over-allocated budget using trait' do
      budget = create(:budget, :over_budget)

      expect(budget.over_allocated?).to be true
    end
  end
end

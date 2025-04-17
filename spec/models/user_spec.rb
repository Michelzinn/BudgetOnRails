require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    describe 'dependent: :destroy' do
      let!(:user) { create(:user) }
      let!(:budget) { create(:budget, user: user) }
      let!(:category) { create(:category, user: user) }
      let!(:expense) { create(:expense, user: user) }

      it 'destroys associated budgets when user is destroyed' do
        expect { user.destroy }.to change { Budget.count }.by(-1)
      end

      it 'destroys associated categories when user is destroyed' do
        expect { user.destroy }.to change { Category.count }.by(-1)
      end

      it 'destroys associated categories when user is destroyed' do
        expect { user.destroy }.to change { Expense.count }.by(-1)
      end
    end
  end
end

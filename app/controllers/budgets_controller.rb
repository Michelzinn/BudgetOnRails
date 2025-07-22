class BudgetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_budget, only: [ :show ]

  def index
    @budgets = current_user.budgets.includes(:categories).order(date: :desc)
  end

  def show
    @categories_with_data = @budget.categories
                                   .includes(:budget_allocations, :expenses)
                                   .joins(:budget_allocations)
                                   .distinct

    @expenses = @budget.expenses
                       .includes(:category)
                       .order(spent_at: :desc)
  end

  private

  def set_budget
    @budget = current_user.budgets.find(params[:id])
  end
end

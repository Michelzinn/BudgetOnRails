class BudgetSummaryTableComponent < ViewComponent::Base
  include MoneyHelper

  def initialize(budget:, categories:)
    @budget = budget
    @categories = categories
  end

  private

  attr_reader :budget, :categories

  def total_allocated
    categories.sum(&:allocation_amount)
  end

  def total_spent
    categories.sum(&:total_expenses)
  end

  def total_remaining
    total_allocated - total_spent
  end

  def row_class(category)
    if category.percentage_used >= 90
      "table-danger"
    elsif category.percentage_used >= 75
      "table-warning"
    else
      ""
    end
  end
end
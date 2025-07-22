class BudgetCardComponent < ViewComponent::Base
  include MoneyHelper

  def initialize(budget:)
    @budget = budget
  end

  private

  attr_reader :budget

  def format_month_year(date)
    I18n.l(date, format: "%B %Y").capitalize
  end

  def budget_status_class
    if budget.percentage_allocated > 100
      "text-danger"
    elsif budget.percentage_allocated == 100
      "text-success"
    else
      "text-warning"
    end
  end

  def categories_summary
    budget.categories.limit(3).pluck(:name).join(", ")
  end

  def total_spent
    budget.expenses.sum(:amount_cents)
  end

  def spent_percentage
    return 0 if budget.total_amount_cents.zero?
    (total_spent.to_f / budget.total_amount_cents * 100).round(2)
  end
end

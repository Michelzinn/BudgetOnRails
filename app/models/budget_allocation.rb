class BudgetAllocation < ApplicationRecord
  belongs_to :budget
  belongs_to :category

  validates :amount_cents_allocated, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def percentage_of_budget
    return 0 if budget.total_amount_cents.zero?
    (amount_cents_allocated.to_f / budget.total_amount_cents * 100).round(2)
  end
end

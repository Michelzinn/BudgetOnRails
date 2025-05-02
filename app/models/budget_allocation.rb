class BudgetAllocation < ApplicationRecord
  belongs_to :budget
  belongs_to :category

  validates :amount_cents_allocated, numericality: { greater_than_or_equal_to: 0 }
end

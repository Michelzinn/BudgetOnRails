class Category < ApplicationRecord
  belongs_to :user
  belongs_to :budget

  has_many :budget_allocations, dependent: :destroy
  has_many :expenses, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :budget_id, message: "already exists for this budget" }

  def total_expenses
    expenses.sum(:amount_cents)
  end

  def allocation_amount
    budget_allocations.where(budget_id: budget_id).sum(:amount_cents_allocated)
  end

  def remaining_allocation
    allocation_amount - total_expenses
  end

  def percentage_used
    return 0 if allocation_amount.zero?
    (total_expenses.to_f / allocation_amount * 100).round(2)
  end

  def over_budget?
    remaining_allocation.negative?
  end
end

class Budget < ApplicationRecord
  belongs_to :user

  has_many :budget_allocations, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :expenses, dependent: :destroy

  validates :total_amount_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true

  def allocated_amount
    budget_allocations.sum(:amount_cents_allocated)
  end

  def remaining_amount
    total_amount_cents - allocated_amount
  end

  def percentage_allocated
    return 0 if total_amount_cents.zero?
    (allocated_amount.to_f / total_amount_cents * 100).round(2)
  end

  def fully_allocated?
    remaining_amount.zero?
  end

  def over_allocated?
    remaining_amount.negative?
  end
end

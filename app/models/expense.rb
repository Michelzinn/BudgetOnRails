class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :budget
  belongs_to :category

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :spent_at, presence: true
end

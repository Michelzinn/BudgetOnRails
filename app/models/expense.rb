class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :budget
  belongs_to :category

  validates :amount_cents, numericality: { greater_than: 0 }
end

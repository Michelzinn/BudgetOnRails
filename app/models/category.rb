class Category < ApplicationRecord
  belongs_to :user
  belongs_to :budget

  has_many :budget_allocations, dependent: :destroy

  has_many :expenses, dependent: :destroy
end

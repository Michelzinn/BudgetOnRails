class Budget < ApplicationRecord
  belongs_to :user

  has_many :budget_allocations, dependent: :destroy
  has_many :categories, dependent: :destroy

  has_many :expenses, dependent: :destroy
end

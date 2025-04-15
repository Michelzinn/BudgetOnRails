class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_many :budgets, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :expenses
end

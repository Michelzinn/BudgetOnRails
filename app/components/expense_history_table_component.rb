class ExpenseHistoryTableComponent < ViewComponent::Base
  include MoneyHelper

  def initialize(expenses:)
    @expenses = expenses
  end

  private

  attr_reader :expenses

  def format_date(date)
    date.strftime("%d/%m/%Y")
  end

  def format_time(date)
    date.strftime("%H:%M")
  end

  def total_expenses
    expenses.sum(&:amount_cents)
  end
end

class CreateBudgetAllocations < ActiveRecord::Migration[8.0]
  def change
    create_table :budget_allocations do |t|
      t.references :budget, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.integer :amount_cents_allocated

      t.timestamps
    end
  end
end

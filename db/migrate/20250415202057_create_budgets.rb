class CreateBudgets < ActiveRecord::Migration[8.0]
  def change
    create_table :budgets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :total_amount
      t.date :date

      t.timestamps
    end
  end
end

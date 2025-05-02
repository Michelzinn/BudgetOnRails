class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.references :budget, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :amount_cents
      t.string :description
      t.datetime :spent_at

      t.timestamps
    end
  end
end

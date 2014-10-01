class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.integer :user_id

      t.timestamps
    end
    add_index :budgets, :user_id
  end
end

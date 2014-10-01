class CreateDefaultItems < ActiveRecord::Migration
  def change
    create_table :default_items do |t|
      t.references :budget, index: true
      t.integer :day
      t.string :name
      t.integer :debit_cents, default: 0
      t.integer :credit_cents, default: 0

      t.timestamps
    end
  end
end

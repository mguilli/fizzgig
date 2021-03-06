class CreateDefaultChanges < ActiveRecord::Migration
  def change
    create_table :default_changes do |t|
      t.integer :day
      t.string :name
      t.integer :debit_cents, default: 0
      t.integer :credit_cents, default: 0
      t.boolean :paid, default: false
      t.references :default_item, index: true
      t.references :month, index: true

      t.timestamps
    end
  end
end

class CreateDefaultChanges < ActiveRecord::Migration
  def change
    create_table :default_changes do |t|
      t.integer :day
      t.string :name
      t.integer :debit_cents
      t.integer :credit_cents
      t.integer :endon
      t.integer :month_changed
      t.references :default_item, index: true

      t.timestamps
    end
  end
end

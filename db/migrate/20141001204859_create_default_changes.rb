class CreateDefaultChanges < ActiveRecord::Migration
  def change
    create_table :default_changes do |t|
      t.integer :day
      t.string :name
      t.integer :debit_cents
      t.integer :credit_cents
      t.date :endon_date, null: false, default: Date.new(3000)
      t.date :date_changed
      t.references :default_item, index: true

      t.timestamps
    end
  end
end

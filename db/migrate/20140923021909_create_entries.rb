class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :name
      t.date :date
      t.boolean :cleared, default: false
      t.integer :credit_cents
      t.integer :debit_cents
      t.references :register, index: true

      t.timestamps
    end
  end
end

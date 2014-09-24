class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :name
      t.date :date
      t.boolean :cleared, default: false
      t.integer :credit_cents, default: 0
      t.integer :debit_cents, default: 0
      t.references :register, index: true

      t.timestamps
    end
  end
end

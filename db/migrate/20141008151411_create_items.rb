class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :day
      t.string :name
      t.integer :debit_cents, default: 0
      t.integer :credit_cents, default: 0
      t.boolean :paid, default: false
      t.integer :default_item_id, default: 0, index: true
      t.references :month, index: true

      t.timestamps
    end
  end
end

class CreateMonths < ActiveRecord::Migration
  def change
    create_table :months do |t|
      t.date :date
      t.integer :movement_cents, default: 0
      t.references :budget, index: true

      t.timestamps
    end
  end
end

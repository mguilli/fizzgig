class CreateRegisters < ActiveRecord::Migration
  def change
    create_table :registers do |t|
      t.string :name
      t.string :acctnumber
      t.integer :user_id

      t.timestamps
    end
    add_index :registers, :user_id
  end
end

class AddAvailableAndClearedToRegister < ActiveRecord::Migration
  def change
    add_column :registers, :available_balance_cents, :integer, default: 0
    add_column :registers, :cleared_balance_cents, :integer, default: 0
  end
end

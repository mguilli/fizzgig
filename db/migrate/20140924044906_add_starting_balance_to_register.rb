class AddStartingBalanceToRegister < ActiveRecord::Migration
  def change
    add_column :registers, :startbalance_cents, :integer, default: 0
  end
end

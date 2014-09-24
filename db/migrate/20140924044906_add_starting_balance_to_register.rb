class AddStartingBalanceToRegister < ActiveRecord::Migration
  def change
    add_column :registers, :startbalance_cents, :integer
  end
end

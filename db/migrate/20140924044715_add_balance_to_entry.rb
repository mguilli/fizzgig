class AddBalanceToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :balance_cents, :integer, default: 0
  end
end

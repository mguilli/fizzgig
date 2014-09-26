class AddRankToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :rank, :integer
    add_index :entries, :rank
  end
end

class Entry < ActiveRecord::Base
  belongs_to :register

  after_save :update_newer_balances

  monetize :credit_cents
  monetize :debit_cents
  monetize :balance_cents

  require 'roo'

  def self.get_excel_seed_data(sheet, start_row, end_row, register_id)
    s = Roo::Excel.new("#{Rails.root}/tmp/FizzgigSampleData.xls")
    s.default_sheet = sheet

    start_row.upto(end_row) do |line|
      cleared = s.cell(line, 'A')
      date = s.cell(line, 'B')
      name = s.cell(line, 'C')
      credit = (s.cell(line, 'D').to_f * 100).round.to_i
      debit = (s.cell(line, 'E').to_f * 100).round.to_i

      new_entry = Entry.new(cleared: cleared, date: date, name: name, credit_cents: credit, 
                            debit_cents: debit, register_id: register_id )
      if new_entry.save
        puts "Entry passed!"
        # new_entry.update_newer_balances
      else
        puts new_entry.errors.full_messages
      end
    end    
  end

  def self.update_after_delete(register_id, lowest_rank)
    # Call private method to update only balances of records ranked higher than lowest ranked deleted record
    # self.update_newer_balances

    xregister = Register.find(register_id)

      if lowest_rank <= 1
        entry_to_update_from = xregister.entries_ranked.last
      else
        rank_to_update_from = lowest_rank - 1
        # Select entry corresponding to that rank
        entry_to_update_from = xregister.entries.find_by(rank: rank_to_update_from)
      end

      entry_to_update_from.update_newer_balances
  end

  # private

  def update_newer_balances
    z = self
    xregister = Register.where(id: z.register_id).first
    xentries = xregister.entries.order(date: :asc).order(credit_cents: :desc)
                                .order(debit_cents: :desc).order(id: :asc)

    key = xentries.pluck(:id) # Get array of ordered entry id's
    position = key.index(z.id) # Get current entry's position in xentries array
    size = key.count


    movement = (z.credit_cents - z.debit_cents)
    # Set balance of current entry based on starting balance or balance of previous item
    if position == 0
      balance_to_here = xregister.startbalance_cents + movement
      new_rank = 1
    else
      balance_to_here = xentries[position-1].balance_cents + movement
      new_rank = xentries[position-1].rank + 1
    end

    # Update current entry's balance & rank
    xentries[position].update_column(:balance_cents, balance_to_here)
    xentries[position].update_column(:rank, new_rank)

    # Debugging
      # puts "id: #{z.id} | #{z.date} | #{z.name} | #{z.debit_cents} | #{z.credit_cents} | #{z.balance_cents}"
      # puts "#{position}/#{size - 1}: #{key}"
      # puts "#{balance_to_here}"

    new_balance = 0
    updated_rank = 0

    # Check if current entry is last entry, and if not, update all later entry balances
    if (position + 1) < size
      (position + 1).upto(size-1) do |k|
        new_balance = xentries[k-1].balance_cents + (xentries[k].credit_cents - xentries[k].debit_cents)
        updated_rank = xentries[k-1].rank + 1
        xentries[k].update_column(:balance_cents, new_balance)
        xentries[k].update_column(:rank, updated_rank)

        # Debugging
          # target = Entry.find(key[k])  
          # puts "k = #{k} | key[k]: #{key[k]} | prev_balance: #{xentries[k-1].balance_cents} | new_balance = #{new_balance}"
          # puts "target-> name: #{target.name} | balance: #{target.balance_cents}"
      end
    end
  end
end
  


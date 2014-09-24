class Entry < ActiveRecord::Base
  belongs_to :register

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
                            debit_cents: debit, register_id: register_id, balance_cents: 0 )
      if new_entry.save
        puts "Entry passed!"
        new_entry.update_balances
      else
        puts new_entry.errors.full_messages
      end
    end    
  end

  def update_balances
    register = Register.where(id: self.register_id).first
    entries = register.entries.order(date: :asc).order(credit_cents: :desc).order(debit_cents: :desc)

    # register.entries.where("date >= ?", 6.months.ago).order(date: :desc).order(credit_cents: :asc).order(debit_cents: :asc)

    key = entries.pluck(:id)
    position = key.index(self.id)
    size = key.count
    
    # Testing block
    # puts position
    # puts self.id
    # puts self.name
    # puts self.debit_cents
    # puts self.credit_cents

    # Set balance of current entry based on starting balance or balance of previous item
    if position == 0
      balance_to_here = register.startbalance_cents + (self.credit_cents - self.debit_cents)
    else
      balance_to_here = entries[position-1].balance_cents + (self.credit_cents - self.debit_cents)
    end

    # Update current entry's balance
    self.update_attribute(:balance_cents, balance_to_here)

    new_balance = 0

    # Check if current entry is latest entry, and if not, update all later entry balances
    if (position + 1) < size
      (position + 1).upto(size-1) do |k|
        new_balance = entries[k-1].balance_cents + (entries[k].credit_cents - entries[k].debit_cents)
        Entry.find(key[k]).update_attribute(:balance_cents, new_balance)
      end
    end
  end
end
  


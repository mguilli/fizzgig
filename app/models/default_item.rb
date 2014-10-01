class DefaultItem < ActiveRecord::Base
  belongs_to :budget

  monetize :credit_cents
  monetize :debit_cents

  def self.set_default_seed(sheet, start_row, end_row, budget_id)
    s = Roo::Excel.new("#{Rails.root}/tmp/FizzgigSampleData.xls")
    s.default_sheet = sheet

    start_row.upto(end_row) do |line|
      name = s.cell(line, 'A')
      day = s.cell(line, 'B')
      credit = (s.cell(line, 'C').to_f * 100).round.to_i
      debit = (s.cell(line, 'D').to_f * 100).round.to_i

      new_default = DefaultItem.new(name: name, day: day, credit_cents: credit, 
                            debit_cents: debit, budget_id: budget_id )
      if new_default.save
        puts "Default saved!"
        # new_default.update_newer_balances
      else
        puts new_default.errors.full_messages
      end
    end    
  end
end

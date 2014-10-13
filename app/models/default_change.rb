class DefaultChange < ActiveRecord::Base
  belongs_to :month
  belongs_to :default_item

  monetize :credit_cents
  monetize :debit_cents

  def self.set_change_seed(sheet, start_row, end_row, budget_id)
    s = Roo::Excel.new("#{Rails.root}/tmp/FizzgigSampleData.xls")
    s.default_sheet = sheet

    start_row.upto(end_row) do |line|
      name = s.cell(line, 'G')
      day = s.cell(line, 'H')
      credit = (s.cell(line, 'I').to_f * 100).round.to_i
      debit = (s.cell(line, 'J').to_f * 100).round.to_i
      default_item_id = s.cell(line, 'K')
      date = s.cell(line, 'L')

      # month = Month.new(budget_id: budget_id, date: date)
      month = Month.find_or_create_by_budget_id_and_date(budget_id, date)

      new_change = DefaultChange.new(name: name, day: day, credit_cents: credit, 
                            debit_cents: debit, default_item_id: default_item_id, month_id: month.id)
      if new_change.save
        puts "Change saved!"
        # new_change.update_newer_balances
      else
        puts new_change.errors.full_messages
      end
    end    
  end
end

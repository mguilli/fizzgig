class DefaultChange < ActiveRecord::Base
  belongs_to :default_item

  monetize :credit_cents
  monetize :debit_cents

  def self.set_change_seed(sheet, start_row, end_row)
    s = Roo::Excel.new("#{Rails.root}/tmp/FizzgigSampleData.xls")
    s.default_sheet = sheet

    start_row.upto(end_row) do |line|
      name = s.cell(line, 'G')
      day = s.cell(line, 'H')
      credit = (s.cell(line, 'I').to_f * 100).round.to_i
      debit = (s.cell(line, 'J').to_f * 100).round.to_i
      date_changed = s.cell(line, 'K')
      endon_date = s.cell(line, 'L')
      default_item_id = s.cell(line, 'M')

      new_change = DefaultChange.new(name: name, day: day, credit_cents: credit, 
                            debit_cents: debit, date_changed: date_changed, endon_date: endon_date,
                            default_item_id: default_item_id)
      if new_change.save
        puts "Change saved!"
        # new_change.update_newer_balances
      else
        puts new_change.errors.full_messages
      end
    end    
  end
end

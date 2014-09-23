class Entry < ActiveRecord::Base
  belongs_to :register

  require 'roo'

  def self.get_excel_seed_data(sheet, start_row, end_row, register_id)
    s = Roo::Excel.new("#{Rails.root}/db/FizzgigSampleData.xls")
    s.default_sheet = sheet

    start_row.upto(end_row) do |line|
      cleared = s.cell(line, 'A')
      date = s.cell(line, 'B')
      name = s.cell(line, 'C')
      credit = (s.cell(line, 'D').to_f * 100).to_i
      debit = (s.cell(line, 'E').to_f * 100).to_i

      Entry.create(cleared: cleared, date: date, name: name, 
                    credit_cents: credit, debit_cents: debit, 
                    register_id: register_id )
    end    
  end
end


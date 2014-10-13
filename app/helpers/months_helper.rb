module MonthsHelper

  def paid_button_status(record)
    if record.class == DefaultItem
      txt1 = 'No!'
      button_to(txt1, pay_default_items_path(id: record.id, date: @this_date), type: 'button', 
                class: 'btn btn-xs btn-warning', method: :post)
    elsif record.class == DefaultChange
      txt1 = record.paid ? 'Yes' : 'No!'
      cls = record.paid ? 'btn-success' : 'btn-warning'

      button_to(txt1, default_change_path(record, :default_change => {paid: !record.paid}), type: 'button', 
                class: "btn btn-xs #{cls}", method: :put)
    else
      txt1 = record.paid ? 'Yes' : 'No!'
      cls = record.paid ? 'btn-success' : 'btn-warning'

      button_to(txt1, item_path(record, :item => {paid: !record.paid}), type: 'button', 
                class: "btn btn-xs #{cls}", method: :put)
    end    
  end

  def increment_balance(record)
    if (record.class == DefaultItem) || (record.paid == false)
      record.credit - record.debit
    else
      Money.new(0)
    end
  end

  def check_date(this_date, record)
    if (Date.valid_date?(this_date.year, this_date.month, record.day)) 
      Date.new(this_date.year, this_date.month, record.day) 
    else 
      Date.civil(this_date.year, this_date.month, -1) 
    end 
  end

  def show_edit(record)
    cls = 'btn btn-xs btn-default'
    if record.class == Item
      link_to('Edit', edit_item_path(record), class: cls)
    elsif record.class == DefaultItem
      link_to('Edit', record, class: cls)
    else
      link_to('Edit', record.default_item, class: cls)        
    end    
  end
end

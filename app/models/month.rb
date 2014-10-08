class Month < ActiveRecord::Base
  belongs_to :budget
  has_many :default_changes
  has_many :items

  monetize :movement_cents

  def write_defaults_to_items(budget)
    # Handle case where item exist with default_item_id = nil
    # Solve case by setting default: 0 for :default_item_id on Item model

    item_def_ids = self.items.pluck(:default_item_id)
    change_def_ids = self.default_changes.pluck(:default_item_id)

    if self.items.empty?
      if self.default_changes.empty?
        defaults_less_existing = budget.default_items
      else
        defaults_less_existing = budget.default_items.where.not('id IN (?)', change_def_ids)
      end
    elsif self.default_changes.empty?
      defaults_less_existing = budget.default_items.where.not('id IN (?)', item_def_ids)
    else
      defaults_less_existing = budget.default_items.where.not('id IN (?) OR id IN (?)', change_def_ids, item_def_ids)
    end 

    defaults_less_existing.each do |x|
      self.items.create( 
          day: x.day,
          name: x.name,
          debit_cents: x.debit_cents,
          credit_cents: x.credit_cents,
          default_item_id: x.id
        )
    end
  end
end

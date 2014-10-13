class Month < ActiveRecord::Base
  belongs_to :budget
  has_many :default_changes
  has_many :items

  monetize :movement_cents

  def self.get_records(budget, this_date, month)
    if this_date.future?
      # Check if @month exists
      if month.nil?
        # If @month == nil, then no changes or paid items have been created
        month_records = Month.gather_and_sort(budget.default_items)
      else
        # Find DefaultItems not changed or marked as paid
        j = month.defs_less_existing(budget)
        month_records = Month.gather_and_sort(j, month.items, month.default_changes)
      end
    else
      month_records = Month.gather_and_sort(month.items, month.default_changes)
    end
  end

  def self.gather_and_sort(a, b=[], c=[])
    collection = a + b + c
    sorted = collection.sort_by {|x| [x.day, -x.credit_cents, -x.debit_cents]}
  end

  def self.get_movement(budget, this_date)
    budget_start_date = budget.start_date.beginning_of_month

    if this_date.future? # Check to see if this_date is in the future
      if this_date == Date.today.next_month.beginning_of_month
        # If this month immediately follows the current month, sum month movements only
        movement = budget.months.sum(:movement_cents)
      else
        # If this month is more than one month in the future from the current month, find a range
        # of months from just after the current month to just before this month
        plus_range = (Date.today.next_month.beginning_of_month .. this_date.prev_month).select {|x| x.day == 1}
        move = 0

        plus_range.each do |z|
          if budget.months.find_by(date: z).nil? == false
            # If month exists for date z 
            mnth = budget.months.find_by(date: z) # month
            dle = mnth.defs_less_existing(budget) # defaultitems less existing
            collection = Month.gather_and_sort(dle, mnth.items, mnth.default_changes)

            # Sum credit and debit for DefaultItems
            move_di = collection.sum {|x| x.class == DefaultItem ? (x.credit_cents - x.debit_cents):0}
            # Sum credit and debit for DefaultChanges and Items except when marked paid
            # binding.pry
            move_dc_i = collection.sum {|x| x.class != DefaultItem ? (x.paid ? 0 : (x.credit_cents - x.debit_cents)) : 0}
            # Increment movement by both DefaultItems and (DefaultChanges & Items)
            move += (move_di + move_dc_i)
          else
            # Movement is only due to default_items
            move += budget.default_items.sum {|x| (x.credit_cents - x.debit_cents)}
          end
        end

        # Add movement from plus_range to current and past month movement
        movement = move + budget.months.sum(:movement_cents)
      end
    else
      # If this month is greater than the budget start month, then total movement == sum of movement for the 
      # budget start month throught the month previous to this_date.  Else this month is the first month in the 
      # budget, and will have movement == 0
      if this_date > budget_start_date
        movement = budget.months.where(date: budget_start_date .. this_date.prev_month).sum(:movement_cents)
      else
        movement = 0      
      end     
    end
    # Return movement
    movement
  end

  def set_movement
    # For months where default_items have been written to items, 
    # sum the credits and debits of items and default_changes,
    # and write to month's movement_cents
    collection = self.items + self.default_changes
    sum = collection.sum {|x| x.paid == false ? (x.credit_cents - x.debit_cents):0}
    self.update_attributes(movement_cents: sum)
  end

  def defs_less_existing(budget)
    item_def_ids = self.items.pluck(:default_item_id)
    change_def_ids = self.default_changes.pluck(:default_item_id)

    if item_def_ids.empty? # self.items.empty?
      if change_def_ids.empty? # self.default_changes.empty?
        dfe = budget.default_items
      else
        dfe = budget.default_items.where.not('id IN (?)', change_def_ids)
      end
    elsif change_def_ids.empty? # self.default_changes.empty?
      dfe = budget.default_items.where.not('id IN (?)', item_def_ids)
    else
      dfe = budget.default_items.where.not('id IN (?) OR id IN (?)', change_def_ids, item_def_ids)
    end     
  end

  def write_defaults_to_items(budget)
    # Handle case where item exist with default_item_id = nil
    # Solve case by setting default: 0 for :default_item_id on Item model

    defaults_less_existing = self.defs_less_existing(budget)

    defaults_less_existing.each do |x|
      self.items.create( 
          day: x.day,
          name: x.name,
          debit_cents: x.debit_cents,
          credit_cents: x.credit_cents,
          default_item_id: x.id
        )
    end

    # Set movement for the month
    self.set_movement
  end

end

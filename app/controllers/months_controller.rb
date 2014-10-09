class MonthsController < ApplicationController
  before_action :authenticate_user!

  def index
    @budget = current_user.budget
    budget_start_date = @budget.start_date.beginning_of_month
    @this_date = params[:date].to_date
    @month = @budget.months.find_by_date(@this_date)
    @default_items = @budget.default_items # May not need -> check for deletion

    # This month
    @register_sum = current_user.registers.sum(:available_balance_cents)
    @starting_balance = @register_sum + Month.get_movement(@budget, @this_date)

    if @this_date.future?
      # Check if @month exists
      if @month.nil?
        # If @month == nil, then no changes or paid items have been created
        @month_records = @budget.default_items
      else
        # Find DefaultItems not changed or marked as paid
        j = @month.defs_less_existing(@budget)
        @month_records = Month.gather_and_sort(j, @month.items, @month.default_changes)
      end
    else
      @month_records = Month.gather_and_sort(@month.items, @month.default_changes)
      
    end

    @prev_month = (@this_date > budget_start_date) ? @this_date.prev_month : nil
    @next_month = @this_date.next_month
      # collection = @month.items + @month.default_changes
      # @month_records = collection.sort_by {|x| [x.day, -x.credit_cents, -x.debit_cents]}
      # j = @default_items.where.not(id: @month.default_changes.pluck(:default_item_id))
      # collection = j + @month.default_changes + @month.items
      # @month_records = collection.sort_by {|x| [x.day, -x.credit_cents, -x.debit_cents]}      
    # # @starting_balance = Register.all.sum(:available_balance_cents)
    # @following_balance = @starting_balance + (@default_items.sum(:credit_cents) - @default_items.sum(:debit_cents))
    # @following_month = @next_date.month
    # @following_year = @next_date.year

    # array = []
    # @default_items.each do |x|
    #   array << x.check_for_change(@this_date)      
    # end

    # @month_records = array.sort_by {|x| [x.day, -x.credit_cents, -x.debit_cents]}

    # hash_array.sort_by {|elem| elem[:date]}

  end

end

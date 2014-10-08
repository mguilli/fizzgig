class MonthsController < ApplicationController
  before_action :authenticate_user!

  def index
    @budget = current_user.budget
    @month = @budget.months.find_by(date: params[:date])
    @default_items = @budget.default_items

    # This month
    @starting_balance = current_user.registers.sum(:available_balance_cents)

    if @month.date > Date.today.beginning_of_month
      j = @default_items.where.not(id: @month.default_changes.pluck(:default_item_id))
      collection = j + @month.default_changes + @month.items
      @items = collection.sort_by {|x| [x.day, -x.credit_cents, -x.debit_cents]}      
    else
      collection = @month.items + @month.default_changes
      @items = collection.sort_by {|x| [x.day, -x.credit_cents, -x.debit_cents]}
    end

    # # @starting_balance = Register.all.sum(:available_balance_cents)
    # @following_balance = @starting_balance + (@default_items.sum(:credit_cents) - @default_items.sum(:debit_cents))
    # @following_month = @next_date.month
    # @following_year = @next_date.year

    # array = []
    # @default_items.each do |x|
    #   array << x.check_for_change(@this_date)      
    # end

    # @items = array.sort_by {|x| [x.day, -x.credit_cents, -x.debit_cents]}

    # hash_array.sort_by {|elem| elem[:date]}
    @prev_month = @month.date.prev_month
    @next_month = @month.date.next_month
  end

end

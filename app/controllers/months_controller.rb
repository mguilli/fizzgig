class MonthsController < ApplicationController
  before_action :authenticate_user!

  def index
    @item = Item.new
    @budget = current_user.budget
    budget_start_date = @budget.start_date.beginning_of_month
    @this_date = params[:date].to_date
    @month = @budget.months.find_by(date: @this_date)
    @default_items = @budget.default_items # May not need -> check for deletion

    @prev_month_date = (@this_date > budget_start_date) ? @this_date.prev_month : nil
    @next_month_date = @this_date.next_month

    # This month
    @register_sum = current_user.registers.sum(:available_balance_cents)
    @starting_balance = @register_sum + Month.get_movement(@budget, @this_date)

    @month_records = Month.get_records(@budget, @this_date, @month)

    # Following month
    @following_month = @budget.months.find_by(date: @next_month_date)
    @following_month_records = Month.get_records(@budget, @next_month_date, @following_month)

  end

end

class BudgetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @budget = current_user.budget
    @default_items = @budget.default_items

    # @starting_balance = Register.all.sum(:available_balance_cents)
    @starting_balance = current_user.registers.sum(:available_balance_cents)
    @following_balance = @starting_balance + (@default_items.sum(:credit_cents) - @default_items.sum(:debit_cents))
    @this_month = params[:month].to_i
    @this_year = params[:year].to_i
    @this_date = Date.new(@this_year, @this_month)
    @prev_date = @this_date.prev_month
    @next_date = @this_date.next_month
    @following_month = @next_date.month
    @following_year = @next_date.year

    array = []
    @default_items.each do |x|
      array << x.check_for_change(@this_date)      
    end

    @items = array.sort_by {|x| [x.day, -x.credit_cents, -x.debit_cents]}

    # hash_array.sort_by {|elem| elem[:date]}
  end
end
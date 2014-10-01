class BudgetsController < ApplicationController
  def index
    @budget = Budget.first
    @default_items = @budget.default_items.order(day: :asc)

    @starting_balance = Register.all.sum(:available_balance_cents)
    # @starting_balance = current_user.registers.sum(:available_balance_cents)
    @following_balance = @starting_balance + (@default_items.sum(:credit_cents) - @default_items.sum(:debit_cents))
    @this_month = params[:month].to_i
    @this_year = params[:year].to_i
    @this_date = Date.new(@this_year, @this_month)
    @prev_date = @this_date.prev_month
    @next_date = @this_date.next_month
    @following_month = (Date.today + 1.month).month
    @following_year = (Date.today + 1.month).year
  end
end

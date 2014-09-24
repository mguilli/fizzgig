class EntriesController < ApplicationController

  def index
    @register = Register.find(params[:register_id])

    @entries = @register.entries.where("date >= ?", 6.months.ago).order(date: :desc)
                        .order(credit_cents: :asc).order(debit_cents: :asc)

    @available_balance = @register.startbalance + Money.new(@register.entries.sum(:credit_cents) - @register.entries.sum(:debit_cents))
    differential = Money.new(@register.entries.where(cleared: false).sum(:credit_cents) - @register.entries.where(cleared: false).sum(:debit_cents))    
    @cleared_balance = @available_balance - differential

  end
end

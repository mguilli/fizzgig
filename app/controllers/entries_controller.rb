class EntriesController < ApplicationController

  def index
    @register = Register.find(params[:register_id])

    @entries = @register.entries.where("date >= ?", 6.months.ago).order(date: :asc)
                        .order(credit_cents: :desc).order(debit_cents: :desc)
                        .order(id: :asc).reverse

    @available_balance = @entries.first.balance
    differential = @register.entries.where(cleared: false).sum(:credit_cents) - @register.entries.where(cleared: false).sum(:debit_cents)    
    @cleared_balance = @available_balance - Money.new(differential)

  end
end

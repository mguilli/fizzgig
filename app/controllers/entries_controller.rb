class EntriesController < ApplicationController

  def index
    @entry = Entry.new
    @register = Register.find(params[:register_id])

    @entries = @register.entries.where("date >= ?", 6.months.ago).order(date: :asc)
                        .order(credit_cents: :desc).order(debit_cents: :desc)
                        .order(id: :asc).reverse

    @available_balance = @entries.first.balance
    differential = @register.entries.where(cleared: false).sum(:credit_cents) - @register.entries.where(cleared: false).sum(:debit_cents)    
    @cleared_balance = @available_balance - Money.new(differential)

  end

  def new
    @entry = Entry.new
  end

  def create
    @register = Register.find(params[:register_id])
    @entry = @register.entries.build(entry_params)

    debit = params[:debit].to_money
    @entry.debit_cents = debit.cents

    credit = params[:credit].to_money
    @entry.credit_cents = credit.cents

    @entry.save

    respond_to do |format|
      format.js do
        render "create"
      end
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:name, :date, :credit_cents, :debit_cents)
  end
end



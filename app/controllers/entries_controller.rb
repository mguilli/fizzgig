class EntriesController < ApplicationController

  def index
    @entry = Entry.new
    @register = Register.find(params[:register_id])

    @entries = @register.ranked

    @available_balance = @register.available_balance
    @cleared_balance = @register.cleared_balance

  end

  def new
    @entry = Entry.new
  end

  def create
    @register = Register.find(params[:register_id])
    @entry = @register.entries.build(entry_params)

    # Any way to get @entries from index to the create.js.erb order to render the table partial?
    @entries = @register.ranked
    @new_entry = Entry.new # To pass to form through JQuery

    debit = params[:debit].to_money
    @entry.debit_cents = debit.cents

    credit = params[:credit].to_money
    @entry.credit_cents = credit.cents

    @entry.save
    # @entry.reload

    respond_to do |format|
      format.js do
        render "create"
      end
    end
  end

  def multiselect
    if params[:commit]
      Entry.where(id: params[:entry_ids]).update_all(cleared: true)
    elsif params[:unclear_button]
      Entry.where(id: params[:entry_ids]).update_all(cleared: false)
    elsif params[:delete_button]
      Entry.where(id: params[:entry_ids]).delete_all      
    end
      redirect_to :back
  end

  private

  def entry_params
    params.require(:entry).permit(:name, :date)
  end
end



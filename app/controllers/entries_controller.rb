class EntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @entry = Entry.new
    @register = Register.find(params[:register_id])

    @entries = @register.entries_ranked

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
    @entries = @register.entries_ranked
    @new_entry = Entry.new # To pass to form through JQuery

    debit = params[:debit].to_money
    @entry.debit_cents = debit.cents

    credit = params[:credit].to_money
    @entry.credit_cents = credit.cents

    @entry.save

    # Need to reload variables to be accessed in js, 
    # since balances changed in after_save event
    @entry.reload
    @register.reload

    respond_to do |format|
      format.js #do
      #   render "create"
      # end
    end
  end

  def multiselect
    @register = Register.find(params[:register_id])

    @cleared = params[:commit]
    @uncleared = params[:unclear_button]
    @multi_delete = params[:delete_button]
    @entry_ids = params[:entry_ids] # Not used in multiselect.js

    # Find lowest rank in entries to be deleted
    lowest_rank = Entry.where(id: @entry_ids).pluck(:rank).min

    if @cleared
      Entry.where(id: @entry_ids).update_all(cleared: true)
    elsif @uncleared
      Entry.where(id: @entry_ids).update_all(cleared: false)
    elsif @multi_delete
      Entry.where(id: @entry_ids).delete_all     
    end

    # Update balances based on lowest ranked entry deleted or updated
    Entry.update_after_multiselect(@register.id, lowest_rank)

    # Load updated balances for multiselect.js
    @register.reload
    @entries = @register.entries_ranked
    @available_balance = @register.available_balance
    @cleared_balance = @register.cleared_balance

    respond_to do |format|
      format.html{ redirect_to :back }
      format.js
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:name, :date)
  end
end



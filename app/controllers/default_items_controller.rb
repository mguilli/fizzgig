class DefaultItemsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
    @default_items = current_user.budget.default_items.order(:day).includes(:default_changes)
  end

  def show
    @default_item = DefaultItem.find(params[:id])
    @changes = @default_item.default_changes.sort_by{|x| x.month.date}
  end

  def pay
    @month = current_user.budget.months.find_or_create_by_date(params[:date])
    @def_item = DefaultItem.find(params[:id])

    @item = @month.items.build(
            day: @def_item.day,
            name: @def_item.name,
            debit_cents: @def_item.debit_cents,
            credit_cents: @def_item.credit_cents,
            paid: true,
            default_item_id: @def_item.id
      )

    if @item.save
      redirect_to :back
    else
      redirect_to root_path
    end    
  end

  private

  def default_item_params
    params.require(:default_item)    
  end
end

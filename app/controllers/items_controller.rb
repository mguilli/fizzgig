class ItemsController < ApplicationController

  def create
    item_date = item_params[:date].to_date
    @month = current_user.budget.months.find_or_create_by(date: Date.new(item_date.year, item_date.month))
    @item = @month.items.build(item_params.except(:date, :credit, :debit))

    @item.day = item_date.day
    debit = item_params[:debit].to_money
    @item.debit_cents = debit.cents
    credit = item_params[:credit].to_money
    @item.credit_cents = credit.cents

    if @item.save
      redirect_to :back
    end

  end

  def update
    @item = Item.find(params[:id])
    @month = @item.month

    if @item.update(item_params.except(:date, :credit, :debit))
      # Adjust month movement if current or past month
      if @month.date.future? == false
        @month.set_movement
      end
      redirect_to :back
    end
  end

  private

  def item_params
    params.require(:item).permit(:paid, :name, :date, :credit, :debit)
  end
end

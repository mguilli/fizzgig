class ItemsController < ApplicationController

  def update
    @item = Item.find(params[:id])
    @month = @item.month

    if @item.update(item_params)
      # Adjust month movement if current or past month
      if @month.date.future? == false
        @month.set_movement
      end
      redirect_to :back
    end
  end

  private

  def item_params
    params.require(:item).permit(:paid)
  end
end

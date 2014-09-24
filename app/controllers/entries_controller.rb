class EntriesController < ApplicationController

  def index
    @register = Register.find(params[:register_id])
    @entries = @register.entries
  end
end

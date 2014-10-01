class RegistersController < ApplicationController
  before_action :authenticate_user!

  def index
    @registers = current_user.registers.all
  end
end

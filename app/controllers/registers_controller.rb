class RegistersController < ApplicationController
  def index
    @registers = Register.all
  end
end

class DefaultChangesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_default_change, only: [:show, :edit, :update, :destroy]

  # GET /default_changes
  # GET /default_changes.json
  def index
    @default_changes = DefaultChange.all
  end

  # GET /default_changes/1
  # GET /default_changes/1.json
  def show
  end

  # GET /default_changes/new
  def new
    @default_change = DefaultChange.new
  end

  # GET /default_changes/1/edit
  def edit
  end

  # POST /default_changes
  # POST /default_changes.json
  def create
    @default_change = DefaultChange.new(default_change_params)

    respond_to do |format|
      if @default_change.save
        format.html { redirect_to @default_change, notice: 'Default change was successfully created.' }
        format.json { render action: 'show', status: :created, location: @default_change }
      else
        format.html { render action: 'new' }
        format.json { render json: @default_change.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /default_changes/1
  # PATCH/PUT /default_changes/1.json
  def update
    @month = @default_change.month

    if @default_change.update(default_change_params)
      # Adjust month movement id current or past month
      if @month.date.future? == false
        @month.set_movement
      end
      redirect_to :back
    end
  end

  # DELETE /default_changes/1
  # DELETE /default_changes/1.json
  def destroy
    @default_change.destroy
    respond_to do |format|
      format.html { redirect_to default_changes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_default_change
      @default_change = DefaultChange.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def default_change_params
      params.require(:default_change).permit(:paid)
    end
end

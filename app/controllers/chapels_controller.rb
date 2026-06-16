class ChapelsController < ApplicationController
  before_action :set_chapel, only: %i[ show edit update destroy ]

  # GET /chapels or /chapels.json
  def index
    @chapels = Chapel.all
  end

  # GET /chapels/1 or /chapels/1.json
  def show
  end

  # GET /chapels/new
  def new
    @chapel = Chapel.new
  end

  # GET /chapels/1/edit
  def edit
  end

  # POST /chapels or /chapels.json
  def create
    @chapel = Chapel.new(chapel_params)

    respond_to do |format|
      if @chapel.save
        format.html { redirect_to @chapel, notice: "Chapel was successfully created." }
        format.json { render :show, status: :created, location: @chapel }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @chapel.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /chapels/1 or /chapels/1.json
  def update
    respond_to do |format|
      if @chapel.update(chapel_params)
        format.html { redirect_to @chapel, notice: "Chapel was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @chapel }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @chapel.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /chapels/1 or /chapels/1.json
  def destroy
    @chapel.destroy!

    respond_to do |format|
      format.html { redirect_to chapels_path, notice: "Chapel was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapel
      @chapel = Chapel.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def chapel_params
      params.expect(chapel: [ :name, :address ])
    end
end

class StatementsController < ApplicationController
  before_action :set_statement, only: %i[ show edit update destroy finalize print ]

  # GET /statements or /statements.json
  def index
    @statements = Statement.all
  end

  # GET /statements/1 or /statements/1.json
  def show
  end

  # GET /statements/new
  def new
    @statement = Statement.new
    @taken_months = Statement.where(year: Date.today.year).pluck(:month)
    @earliest_statement = Statement.order(:year, :month).first
  end

  # GET /statements/1/edit
  def edit
    redirect_to @statement, notice: "Statement is finalized and cannot be edited." if @statement.is_finalized?

    @taken_months = Statement.where(year: @statement.year).pluck(:month)
    @earliest_statement = Statement.order(:year, :month).first
  end

  # POST /statements or /statements.json
  def create
    @statement = Statement.new(statement_params)

    respond_to do |format|
      if @statement.save
        format.html { redirect_to @statement, notice: "Statement was successfully created." }
        format.json { render :show, status: :created, location: @statement }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @statement.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /statements/1 or /statements/1.json
  def update
    respond_to do |format|
      if @statement.update(statement_params)
        format.html { redirect_to @statement, notice: "Statement was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @statement }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @statement.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /statements/1 or /statements/1.json
  def destroy
    @statement.destroy!

    respond_to do |format|
      format.html { redirect_to statements_path, notice: "Statement was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def finalize
    if @statement.finalize!
      redirect_to @statement,
        notice: "Statement was successfully finalized.",
        status: :see_other
    else
      redirect_to edit_statement_path(@statement),
        alert: "Unable to finalize statement."
    end
  end

  def print
  end

  # GET /statements/taken_months?year=2026
  def taken_months
    taken = Statement.where(year: params[:year]).pluck(:month)
    earliest = Statement.order(:year, :month).first

    render json: {
      taken_months: taken,
      earliest: earliest ? { month: earliest.month, year: earliest.year } : nil
    }
  end

  # GET /statements/beginning_balance?month=january&year=2026
  def beginning_balance
    statement = Statement.find_or_initialize_by(
      month: params[:month],
      year: params[:year]
    )

    render json: {
      beginning_balance: statement.beginning_balance
    }
  end

  private
    def set_statement
      @statement = Statement.includes(transactions: :account).find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def statement_params
      params.expect(
        statement: [
          :month,
          :year,
          :prepared_by_id,
          :approved_by_id,
          :initial_balance,
          transactions_attributes: [
            [ :id, :account_id, :description, :amount, :_destroy ]
          ]
        ]
      )
    end
end

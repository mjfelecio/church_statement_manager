class PagesController < ApplicationController
  def home
    current_year = Date.today.year

    @accounts_count = Account.count
    @people_count = Person.count
    @statements_count = Statement.count
    @finalized_count = Statement.where.not(finalized_at: nil).count
    @draft_count = @statements_count - @finalized_count

    @recent_statements = Statement.order(year: :desc, month: :desc).limit(5)
    @latest_statement = @recent_statements.first

    @ytd_income = Transaction.joins(:statement, :account)
      .where(statements: { year: current_year }, accounts: { category: :income })
      .sum(:amount)

    @ytd_expenses = Transaction.joins(:statement, :account)
      .where(statements: { year: current_year }, accounts: { category: :expense })
      .sum(:amount)
  end
end

module StatementsHelper
  def person_options
    Person.all.map { |person| [ person.name, person.id ] }
  end

  def month_options(statement_month)
    options_for_select(
      Statement.months.map { |k, v| [ k.humanize, k ] },
      {
        selected: statement_month || Date::MONTHNAMES[Date.today.month].downcase
      }
    )
  end

  def account_options(account_id, category)
    options_from_collection_for_select(
      Account.where(category: category).order(:name),
      :id,
      :name,
      account_id
    )
  end

  def last_day_of_month_of_statement(statement)
    Date.new(statement.year, Statement.months[statement.month], -1).strftime("%B %-d, %Y")
  end
end

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

  def account_options(account_id)
    options_for_select(
      Account.all.order(:category, :name).map do |a|
        [ a.name, a.id,
          {
            data: { category: a.category }
          }
        ]
      end,
      {
        selected: account_id
      }
    )
  end

  def default_category
    Account.order(:category, :name).first&.category || "income"
  end

  def last_day_of_month_of_statement(statement)
    Date.new(statement.year, Statement.months[statement.month], -1).strftime("%B %-d, %Y")
  end
end

module StatementsHelper
  def person_options
    Person.all.map { |person| [ person.name, person.id ] }
  end

  def month_options(statement_month, taken_months: [], earliest: nil, selected_year: nil)
    options = Statement.months.map do |key, month_num|
      disabled = false

      disabled = true if taken_months.include?(key.to_s) && statement_month != key.to_s

      if earliest && selected_year
        if selected_year.to_i < earliest[:year]
          disabled = true
        elsif selected_year.to_i == earliest[:year] && month_num < Statement.months[earliest[:month]]
          disabled = true
        end
      end

      [ key.humanize, key, { disabled: disabled } ]
    end

    options_for_select(
      options,
      selected: statement_month || Date::MONTHNAMES[Date.today.month].downcase
    )
  end

  def account_options(account_id, category)
    options_from_collection_for_select(
      Account.where(category: category).order(:name),
      :id,
      :display_name,
      account_id
    )
  end

  def last_day_of_month_of_statement(statement)
    Date.new(statement.year, Statement.months[statement.month], -1).strftime("%B %-d, %Y")
  end
end

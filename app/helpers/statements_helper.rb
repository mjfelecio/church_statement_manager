module StatementsHelper
  # TODO: In the future a person will be associated with a Chapel
  # We should make it so that only persons who are associated with
  # the chapel this statement belongs to gets shown, instead of all
  # people being selectable
  def person_options
    Person.all.map { |person| [ person.name, person.id ] }
  end

  def chapel_options
    Chapel.all.map { |chapel| [ chapel.name, chapel.id ] }
  end

  def month_options
    Statement.months.map { |k, v| [ k.humanize, k ] }
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
    Account.order(:category, :name).first&.category || "asset"
  end
end

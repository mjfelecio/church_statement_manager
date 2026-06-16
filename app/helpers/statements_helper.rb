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
    Statement.months.map { |k, v| [ k.humanize, v ] }
  end
end

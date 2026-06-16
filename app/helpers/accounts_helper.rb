module AccountsHelper
  def badge_variant(category)
    case category.to_sym
    when :income
      "badge-accent"
    when :expense
      "badge-error"
    when :asset
      "badge-primary"
    else
      "badge-outline"
    end
  end

  def category_options
    Account.categories.map { |k, v| [ k.humanize, k.to_sym ] }
  end
end

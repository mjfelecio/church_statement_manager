class Statement < ApplicationRecord
  belongs_to :prepared_by, class_name: "Person"
  belongs_to :approved_by, class_name: "Person"

  has_many :transactions, dependent: :destroy

  accepts_nested_attributes_for :transactions, allow_destroy: true, reject_if: :all_blank

  CHAPEL_NAME = "San Roque Chapel"
  CHAPEL_ADDRESS = "Nangka, Mabini, Bohol"

  # matches DATE::MONTHNAMES conversion
  enum :month, {
      january: 1,
      february: 2,
      march: 3,
      april: 4,
      may: 5,
      june: 6,
      july: 7,
      august: 8,
      september: 9,
      october: 10,
      november: 11,
      december: 12
  }

  validates :year, :month, presence: true
  validates :initial_balance, presence: true, numericality: {
    greater_than_or_equal_to: 0
  }, unless: -> { initial_balance_statement_present? }

  validates :month,
    uniqueness: {
      scope: [ :year ],
      message: "already exists for this year"
    }

  validates :year,
    numericality: {
      greater_than_or_equal_to: 0
    }

  validate :prepared_and_approved_by_must_differ
  validate :cannot_be_edited_when_finalized, on: [ :update, :destroy ]
  validate :only_one_initial_balance

  def display_name
    "#{self.year}-#{self.month.titlecase}-Financial-Statement"
  end

  def month_number
    Statement.months[month]
  end

  def previous_statement
    return nil if month.blank? || year.blank?

    Statement
      .where(
        "year < :year OR (year = :year AND month < :month)",
        year: year,
        month: month_number
      )
      .order(year: :desc, month: :desc)
      .first
  end

  def income_transactions
    transactions.joins(:account).where(account: { category: :income })
  end

  def expense_transactions
    transactions.joins(:account).where(account: { category: :expense })
  end

  def total_income
    income_transactions.sum(:amount) || 0
  end

  def total_expenses
    expense_transactions.sum(:amount) || 0
  end

  # This is the amount of cash we have at the beginning of the month plus the total income
  # It represents the amount of cash we have available to spend this month
  def available_funds
    beginning_balance + total_income
  end

  # This is the amount of cash we have at the beginning of the month
  def beginning_balance
    previous_statement&.ending_balance || initial_balance || 0
  end

  # This is the amount of cash we have at the end of the month after accounting for income and expenses
  def ending_balance
    beginning_balance + total_income - total_expenses
  end

  def is_finalized?
    finalized_at.present?
  end

  def finalize!
    update_columns(finalized_at: DateTime.current)
  end

  def initial_balance_statement
     Statement
       .where.not(initial_balance: nil)
       .order(:id)
       .first
   end

  # Initial balance is the amount of cash we have at the very first statement
  def initial_balance_statement_present?
    initial_balance_statement.present?
  end

  private

  def prepared_and_approved_by_must_differ
    return if prepared_by_id.blank? || approved_by_id.blank?

    if prepared_by_id == approved_by_id
      errors.add(:approved_by_id, "must be different from prepared by")
    end
  end

  def cannot_be_edited_when_finalized
    return unless is_finalized?

    errors.add(:base, "Statement is finalized and cannot be edited.")
  end

  def only_one_initial_balance
    return unless initial_balance.present?
    return unless initial_balance_statement_present?
    return if initial_balance_statement == self

    errors.add(:base, "Only one initial balance is allowed.")
  end
end

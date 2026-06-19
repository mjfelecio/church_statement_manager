class Transaction < ApplicationRecord
  belongs_to :statement
  belongs_to :account

  validates :amount,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 0
    }

  validate :cannot_be_edited_when_finalized

  def cannot_be_edited_when_finalized
    return unless statement.is_finalized?

    errors.add(:base, "Transaction cannot be edited when statement is finalized.")
  end
end

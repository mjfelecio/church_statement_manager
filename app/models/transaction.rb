class Transaction < ApplicationRecord
  belongs_to :statement
  belongs_to :account

  validates :amount,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 0
    }

  validates :account_id,
    uniqueness: {
      scope: :statement_id,
      message: "has already been taken for this statement"
    },
    if: -> { account_id.present? }

  validate :cannot_be_edited_when_finalized, on: [ :update, :destroy ]

  def cannot_be_edited_when_finalized
    return unless statement.is_finalized?

    errors.add(:base, "Transaction cannot be edited when statement is finalized.")
  end

  def group_name
    account&.group
  end
end

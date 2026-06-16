class Transaction < ApplicationRecord
  belongs_to :statement

  enum kind: {
    income: 0,
    expense: 1
  }

  validates :kind, :account_code, :name, :amount, presence: true

  validates :amount,
    numericality: {
      greater_than_or_equal_to: 0
    }
end

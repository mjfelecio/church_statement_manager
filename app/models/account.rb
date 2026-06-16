class Account < ApplicationRecord
  has_many :transactions, dependent: :restrict_with_error

  enum :category, {
    asset: 0,
    income: 1,
    expense: 2
  }

  validates :code, :name, :category, presence: true
end

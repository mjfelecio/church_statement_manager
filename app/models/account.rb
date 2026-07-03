class Account < ApplicationRecord
  has_many :transactions, dependent: :restrict_with_error

  enum :category, {
    income: 0,
    expense: 1
  }

  validates :code, :name, :category, presence: true

  validates :code, uniqueness: true
end

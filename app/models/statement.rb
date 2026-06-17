class Statement < ApplicationRecord
  belongs_to :chapel
  belongs_to :prepared_by, class_name: "Person"
  belongs_to :approved_by, class_name: "Person"

  has_many :transactions, dependent: :destroy

  accepts_nested_attributes_for :transactions, allow_destroy: true, reject_if: :all_blank

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

  validates :year, :month, :chapel_id, presence: true

  validates :month,
    uniqueness: {
      scope: [ :year, :chapel_id ],
      message: "already exists for this chapel and year"
    }

  validates :year,
    numericality: {
      greater_than_or_equal_to: 0
    }

  validates :beginning_balance,
    numericality: {
      greater_than_or_equal_to: 0
    }

  validates :ending_balance,
    numericality: {
      greater_than_or_equal_to: 0
    }

  validate :prepared_and_approved_by_must_differ

  private

  def prepared_and_approved_by_must_differ
    return if prepared_by_id.blank? || approved_by_id.blank?

    if prepared_by_id == approved_by_id
      errors.add(:approved_by_id, "must be different from prepared by")
    end
  end
end

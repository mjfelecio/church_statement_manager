class Person < ApplicationRecord
  has_many :prepared_statements,
             class_name: "Statement",
             foreign_key: :prepared_by_id,
             dependent: :restrict_with_error

  has_many :approved_statements,
             class_name: "Statement",
             foreign_key: :approved_by_id,
             dependent: :restrict_with_error
end

class Statement < ApplicationRecord
  belongs_to :chapel
  belongs_to :prepared_by, class_name: "Person"
  belongs_to :approved_by, class_name: "Person"
end

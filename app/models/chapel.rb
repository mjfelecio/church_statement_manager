class Chapel < ApplicationRecord
  has_many :statements, dependent: :restrict_with_error
end

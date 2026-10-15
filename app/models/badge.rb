class Badge < ApplicationRecord
  has_many :volunteers

  validates :name, presence: true
  validates :required_points, presence: true,
            numericality: { only_integer: true, greater_than: 0 }
  validates :required_event, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true
end

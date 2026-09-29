class Badge < ApplicationRecord
  validates :name, :required_points, presence: true
end

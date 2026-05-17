class Place < ApplicationRecord
  has_many :events, dependent: :nullify

  validates :name, :category, :description, presence: true
  validates :wifi_score, :quiet_score, presence: true, numericality: { only_integer: true, in: 1..10 }
  validates :map_x, :map_y, numericality: { only_integer: true, in: 0..100 }, allow_nil: true
  validates :latitude, numericality: true, allow_nil: true
  validates :longitude, numericality: true, allow_nil: true
end

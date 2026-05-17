class Event < ApplicationRecord
  belongs_to :place, optional: true
  has_many :tickets, dependent: :destroy

  validates :title, :event_type, :description, :starts_at, :location, presence: true
  validates :ticket_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :ticket_price, presence: true, if: :ticket_required?

  scope :upcoming, -> { where("starts_at >= ?", Time.current).order(:starts_at) }

  def free?
    !ticket_required?
  end

  def outdoor?
    text = "#{location} #{place&.category} #{place&.location_label}".downcase
    text.include?("bahçe") || text.include?("açık") || text.include?("sahne") || text.include?("stadyum")
  end
end

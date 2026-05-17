class Ticket < ApplicationRecord
  belongs_to :event
  belongs_to :user

  attr_accessor :card_number, :expiry_month, :expiry_year, :cvv

  before_validation :normalize_payment_fields

  validates :quantity, numericality: { only_integer: true, in: 1..5 }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
  validates :card_holder_name, presence: true
  validates :payer_iban, presence: true
  validate :card_number_must_be_valid
  validate :expiry_date_must_be_valid
  validate :cvv_must_be_valid
  validate :payer_iban_must_be_turkish_format

  private

    def normalize_payment_fields
      self.card_holder_name = card_holder_name.to_s.strip
      self.card_number = card_number.to_s.gsub(/\D/, "")
      self.cvv = cvv.to_s.gsub(/\D/, "")
      self.expiry_month = expiry_month.to_s.strip
      self.expiry_year = expiry_year.to_s.strip
      self.payer_iban = payer_iban.to_s.upcase.gsub(/\s+/, "")
      self.card_last_four = card_number.to_s.last(4) if card_number.present?
    end

    def card_number_must_be_valid
      return if card_number.to_s.match?(/\A\d{16}\z/)

      errors.add(:card_number, "16 haneli olmalıdır")
    end

    def expiry_date_must_be_valid
      month = expiry_month.to_i
      year = expiry_year.to_i

      unless month.between?(1, 12) && expiry_year.to_s.match?(/\A\d{4}\z/)
        errors.add(:expiry_year, "geçerli bir son kullanma tarihi olmalıdır")
        return
      end

      expiry_date = Date.new(year, month, -1)
      errors.add(:expiry_year, "geçmiş bir tarih olamaz") if expiry_date < Date.current
    rescue Date::Error
      errors.add(:expiry_year, "geçerli bir son kullanma tarihi olmalıdır")
    end

    def cvv_must_be_valid
      return if cvv.to_s.match?(/\A\d{3,4}\z/)

      errors.add(:cvv, "3 veya 4 haneli olmalıdır")
    end

    def payer_iban_must_be_turkish_format
      return if payer_iban.to_s.match?(/\ATR\d{24}\z/)

      errors.add(:payer_iban, "TR ile başlamalı ve toplam 26 karakter olmalıdır")
    end
end

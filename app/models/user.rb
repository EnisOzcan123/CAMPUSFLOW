class User < ApplicationRecord
  has_secure_password
  has_many :tickets, dependent: :destroy

  ROLES = %w[user admin].freeze

  before_validation :normalize_email
  before_validation :normalize_role

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :role, inclusion: { in: ROLES }

  def admin?
    role == "admin"
  end

  def role_name
    admin? ? "Admin" : "Normal kullanıcı"
  end

  private

    def normalize_email
      self.email = email.to_s.strip.downcase
    end

    def normalize_role
      self.role = role.presence_in(ROLES) || "user"
    end
end

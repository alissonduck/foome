class Company < ApplicationRecord
  # Relacionamentos
  has_many :offices, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :teams, dependent: :destroy

  # Validações
  validates :name, presence: true
  validates :cnpj, presence: true, uniqueness: true

  # Callbacks
  before_save :set_defaults

  private

  def set_defaults
    self.active = true if self.active.nil?
    self.max_users ||= 10
    self.onboarding_completed ||= false
    self.terms_accepted ||= false
  end
end

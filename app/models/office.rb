class Office < ApplicationRecord
  # Relacionamentos
  belongs_to :company
  belongs_to :city
  has_many :employees, dependent: :nullify
  has_one :state, through: :city

  # Validações
  validates :name, presence: true, length: { maximum: 255 }
  validates :zip_code, presence: true, format: { with: /\A\d{8}\z/, message: "deve conter 8 dígitos" }
  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :city_id, presence: true
  validates :company_id, presence: true

  # Callbacks
  before_save :set_defaults
  before_validation :normalize_zip_code

  private

  def set_defaults
    self.active = true if self.active.nil?
  end

  def normalize_zip_code
    self.zip_code = zip_code.to_s.gsub(/\D/, "") if zip_code.present?
  end
end

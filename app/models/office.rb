class Office < ApplicationRecord
  # Relacionamentos
  belongs_to :company
  belongs_to :city
  has_many :employees, dependent: :nullify

  # Validações
  validates :name, presence: true
  validates :zip_code, presence: true

  # Callbacks
  before_save :set_defaults

  private

  def set_defaults
    self.active = true if self.active.nil?
  end
end

class Team < ApplicationRecord
  # Relacionamentos
  belongs_to :company
  belongs_to :manager, class_name: "Employee", optional: true
  has_many :employees, dependent: :nullify

  # Validações
  validates :name, presence: true

  # Callbacks
  before_save :set_defaults

  private

  def set_defaults
    self.active = true if self.active.nil?
  end
end

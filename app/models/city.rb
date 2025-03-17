class City < ApplicationRecord
  # Relacionamentos
  belongs_to :state
  has_many :offices
  has_many :partners

  # Validações
  validates :name, presence: true
  validates :state_id, presence: true
end

class State < ApplicationRecord
  # Relacionamentos
  has_many :cities, dependent: :destroy

  # Validações
  validates :name, presence: true
  validates :abbreviation, presence: true, length: { is: 2 }, uniqueness: { case_sensitive: false }
end

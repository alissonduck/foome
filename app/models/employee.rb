class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
  # Removemos :registerable para evitar registro direto via Devise

  # Relacionamentos
  belongs_to :company
  belongs_to :office, optional: true
  belongs_to :team, optional: true
  belongs_to :manager, class_name: "Employee", optional: true
  has_many :subordinates, class_name: "Employee", foreign_key: "manager_id", dependent: :nullify
  has_one :managed_team, class_name: "Team", foreign_key: "manager_id", dependent: :nullify

  # Validações
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :internal_id, uniqueness: { scope: :company_id }, allow_blank: true

  # Callbacks
  before_save :set_defaults

  # Scopes
  scope :admins, -> { where(role: "admin") }
  scope :managers, -> { where(role: "manager") }
  scope :members, -> { where(role: "member") }
  scope :active, -> { where(active: true) }

  # Métodos
  def admin?
    role == "admin"
  end

  def manager?
    role == "manager"
  end

  def member?
    role == "member"
  end

  private

  def set_defaults
    self.active = true if self.active.nil?
    self.role ||= "admin"
  end
end

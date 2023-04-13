class Member < ApplicationRecord
  belongs_to :team

  has_many :project_members, dependent: :destroy
  has_many :projects, through: :project_members

  validates :first_name, :last_name, presence: true
  validates :first_name, uniqueness: { scope: :last_name, case_sensitive: false }

  def name
    "#{first_name} #{last_name}"
  end
end

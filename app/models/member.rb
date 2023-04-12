class Member < ApplicationRecord
  belongs_to :team

  has_many :project_members, dependent: :nullify
  has_many :projects, through: :project_members

  validates :first_name, :last_name, presence: true

  before_update :verify_team_exists, if: :team_id_changed?

  private

  def verify_team_exists
    errors.add(:base, "team with #{team_id} does not exists") unless Team.exists?(id: team_id)
  end
end

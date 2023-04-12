class ProjectMember < ApplicationRecord
  belongs_to :member
  belongs_to :project

  validates :member, :project, presence: true
  validates :project_id, uniqueness: { scope: :member_id }
end

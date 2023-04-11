class Project < ApplicationRecord
  has_many :project_members, dependent: :nullify
  has_many :members, through: :project_members

  validates :name, presence: true
end

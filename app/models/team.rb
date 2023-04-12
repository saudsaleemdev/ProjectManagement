class Team < ApplicationRecord
  has_many :members, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end

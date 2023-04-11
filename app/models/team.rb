class Team < ApplicationRecord
  has_many :members, dependent: :nullify

  validates :name, presence: true
end

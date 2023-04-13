require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'associations' do
    it { should have_many(:members).dependent(:destroy) }
  end

  describe 'validations' do
    let!(:team) { create(:team) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    it 'is valid with valid attributes' do
      expect(team).to be_valid
    end

    it 'is invalid without a name' do
      team.name = nil
      expect(team).not_to be_valid
    end
  end
end

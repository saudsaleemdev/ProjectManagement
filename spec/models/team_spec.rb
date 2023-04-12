require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'validations' do
    let(:team) { create(:team) }

    it 'is valid with valid attributes' do
      expect(team).to be_valid
    end

    it 'is invalid without a name' do
      team.name = nil
      expect(team).not_to be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:members).dependent(:nullify) }
  end
end

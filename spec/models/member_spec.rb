require 'rails_helper'

RSpec.describe Member, type: :model do
  describe 'validations' do
    let(:member) { create(:member) }

    it 'is valid with valid attributes' do
      expect(member).to be_valid
    end

    it 'is invalid without a first name' do
      member.first_name = nil
      expect(member).not_to be_valid
    end

    it 'is invalid without a last name' do
      member.last_name = nil
      expect(member).not_to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:team) }
    it { should have_many(:project_members).dependent(:nullify) }
    it { should have_many(:projects).through(:project_members) }
  end
end

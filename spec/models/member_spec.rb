require 'rails_helper'

RSpec.describe Member, type: :model do
  describe 'associations' do
    it { should belong_to(:team) }
    it { should have_many(:project_members).dependent(:destroy) }
    it { should have_many(:projects).through(:project_members) }
  end

  describe 'validations' do
    let!(:member) { create(:member) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_uniqueness_of(:first_name).scoped_to(:last_name).case_insensitive }

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
end

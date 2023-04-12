require 'rails_helper'

RSpec.describe ProjectMember, type: :model do
  describe 'associations' do
    it { should belong_to(:member) }
    it { should belong_to(:project) }
  end

  describe 'validations' do
    let!(:project_member) { create(:project_member) }

    it { should validate_presence_of(:member) }
    it { is_expected.to validate_uniqueness_of(:project_id).scoped_to(:member_id) }

    it 'is valid with valid attributes' do
      expect(project_member).to be_valid
    end

    it 'is invalid without a member' do
      project_member.member = nil
      expect(project_member).not_to be_valid
    end

    it 'is invalid without a project' do
      project_member.project = nil
      expect(project_member).not_to be_valid
    end
  end
end

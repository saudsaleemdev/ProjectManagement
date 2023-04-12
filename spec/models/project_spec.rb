require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should have_many(:project_members).dependent(:nullify) }
    it { should have_many(:members).through(:project_members) }
  end

  describe 'validations' do
    let(:project) { create(:project) }

    it 'is valid with valid attributes' do
      expect(project).to be_valid
    end

    it 'is invalid without a name' do
      project.name = nil
      expect(project).not_to be_valid
    end
  end
end

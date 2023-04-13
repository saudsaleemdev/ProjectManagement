FactoryBot.define do
  factory :project do
    name { Faker::Name.first_name }

    trait :with_member do
      after(:create) do |project|
        create(:project_member, project: project)
      end
    end
  end
end

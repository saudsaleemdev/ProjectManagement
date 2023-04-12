FactoryBot.define do
  factory :team do
    name { Faker::Team.name }

    trait :with_member do
      after(:create) do |team|
        create_list(:member, 2, team: team)
      end
    end
  end
end

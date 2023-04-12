FactoryBot.define do
  factory :member do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.first_name }
    city { Faker::Address.city }
    state { Faker::Address.state }
    country { Faker::Address.country }
    team

    trait :with_projects do
      after(:create) do |member|
        create_list(:project_member, 2, member: member)
      end
    end
  end
end

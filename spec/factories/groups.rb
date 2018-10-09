FactoryBot.define do
  factory :group do
    name { Faker::Company.unique.name[1..30] }
    description { Faker::Company.catch_phrase }
  end
end

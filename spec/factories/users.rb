FactoryBot.define do
  factory :user do
    username { Faker::Name.unique.first_name[1..6] }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password }
    phone { '01234567890' }
    activated { true }
    activated_time { Time.zone.now }
  end
end

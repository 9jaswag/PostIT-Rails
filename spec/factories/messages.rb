FactoryBot.define do
  factory :message do
    title { Faker::Lorem.word }
    body { Faker::Lorem.paragraph(2) }
    readby { [Faker::Name.unique.first_name[1..6]] }
    group_id { 1 }
    user_id { 1 }
    priority { 'urgent' }
  end
end

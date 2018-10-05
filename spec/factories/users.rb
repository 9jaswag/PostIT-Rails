FactoryBot.define do
  factory :user do
    username { 'chuks' }
    email { 'chuks@email.com' }
    password { 'secret_password' }
    phone { '01234567890' }
  end
end

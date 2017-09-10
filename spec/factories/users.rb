FactoryGirl.define do
  sequence(:email) { |n| "no-one-#{n}@example.com" }

  factory :user do
    email
    password "password"
    password_confirmation "password"
    location "escondido, ca"
    admin false
  end
end
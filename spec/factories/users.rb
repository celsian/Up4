FactoryGirl.define do
  sequence(:email) { |n| "no-one-#{n}@example.com" }

  factory :user do
    email
    password "password"
    password_confirmation "password"
    admin false
  end
end
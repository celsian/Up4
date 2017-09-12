FactoryGirl.define do
  sequence(:email) { |n| "no-one-#{n}@example.com" }

  factory :user do
    email
    password "password"
    password_confirmation "password"
    location "escondido, ca"
    latitude "33.1192068".to_f
    longitude "-117.086421".to_f
    admin false
  end
end
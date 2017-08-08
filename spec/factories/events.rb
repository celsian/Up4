FactoryGirl.define do
  factory :event do
    name "Wonder Woman (Orange)"
    description "Before she was Wonder Woman (Gal Gadot), she was Diana, princess of the Amazons."
    time_date Time.now+3.hours
    time Time.now+3.hours
    location "20 City Blvd W E, Orange, CA 92868"
    association :owner, factory: :user

    trait :in_the_past do
      time_date (Time.now-3.hours).to_s
      time Time.now-3.hours
      to_create {|instance| instance.save(validate: false) }
    end
  end
end

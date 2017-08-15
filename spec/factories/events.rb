FactoryGirl.define do
  factory :event do
    name "Wonder Woman (Orange)"
    description "Before she was Wonder Woman (Gal Gadot), she was Diana, princess of the Amazons."
    time_date (Time.current+3.hours).strftime("%F %I:%M %p %:z")
    location "value is stubbed, see default spec"
    association :owner, factory: :user

    trait :miles_away do
      location "Vista, CA"
    end

    trait :far_away do
      location "New York, NY"
    end

    trait :in_the_past do
      time_date (Time.current-3.hours).strftime("%F %I:%M %p %:z")
      to_create {|instance| instance.save(validate: false) }
    end
  end
end

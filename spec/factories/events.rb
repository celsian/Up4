FactoryGirl.define do
  factory :event do
    name "Wonder Woman (Escondido)"
    description "Before she was Wonder Woman (Gal Gadot), she was Diana, princess of the Amazons."
    time_date Time.now+3.hours
    location "350 W Valley Pkwy, Escondido, CA 92025"
    association :owner, factory: :user
  end
end

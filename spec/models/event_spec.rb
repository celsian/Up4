require 'rails_helper'

RSpec.describe Event, type: :model do
  before(:all) do
    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.set_default_stub(
      [
        {
          'latitude'     => 40.7143528,
          'longitude'    => -74.0059731,
          'address'      => 'New York, NY, USA',
          'state'        => 'New York',
          'state_code'   => 'NY',
          'country'      => 'United States',
          'country_code' => 'US'
        }
      ]
    )
  end

  let(:event) { create(:event) }

  describe "validate" do
    it "does not allow empty name" do
      event = Event.create(name: "", location: "Address", description: "", time_date: (Time.current+3.hours).strftime("%Y-%m-%d %I:%M %p"))

      expect(event.error_messages).to include("Name can't be blank")
    end

    it "does not allow empty location" do
      event = Event.create(name: "Hi", location: "", description: "", time_date: (Time.current+3.hours).strftime("%Y-%m-%d %I:%M %p"))

      expect(event.error_messages).to include("Location can't be blank")
    end

    it "populates longitude and latitude" do
      expect(event.latitude).to eq(40.7143528)
      expect(event.longitude).to eq(-74.0059731)
    end

    it "belongs to a user" do
      expect(event.owner.class).to eq(User)
    end
  end

  describe "#time_date_format" do
    it "validates the format" do
      event = Event.new(name: "hi", description: "test event", location: "somewhere", time_date: "INCORRECT TIME")
      event.save

      expect(event.error_messages).to include("Time & date format invalid")
    end
  end

  describe "#time_date_future" do
    it "validates event is in the future" do
      event = Event.new(name: "hi", description: "test event", location: "somewhere", time_date: "2017-08-01 11:00 AM -07:00")
      event.save

      expect(event.error_messages).to include("Time & date must be a future event")
    end
  end

  describe "#time_update" do
    it "updates the time object for sql queries" do
      #before_validation calls time_update
      expect(event.time).to eq(event.time_date)
    end
  end

  describe "#formatted_time" do
    it "returns the time_date in a formatted string" do
      expect(event.formatted_time).to include(event.time_date.to_time.strftime("%l:%M %p on %A, %B %-d, %Y %z"))
    end
  end

  describe "#formatted_time_short" do
    it "returns the time_date in a formatted string" do
      expect(event.formatted_time_short).to include(event.time_date.to_time.strftime("%l:%M %p"))
    end
  end

  describe "#formatted_time_long" do
    it "returns the time_date in a formatted string" do
      expect(event.formatted_time_long).to include(event.time_date.to_time.strftime("%D"))
    end
  end
end

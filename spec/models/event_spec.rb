require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { create(:event) }

  describe "validate" do
    it "does not allow empty name" do
      event = Event.create(name: "", location: "Address", description: "", time_date: "08/17/2017 11:00 AM")

      expect(event.error_messages).to include("Name can't be blank")
    end

    it "does not allow empty location" do
      event = Event.create(name: "Hi", location: "", description: "", time_date: "08/17/2017 11:00 AM")

      expect(event.error_messages).to include("Location can't be blank")
    end

    it "belongs to a user" do
      expect(event.owner.class).to eq(User)
    end
  end

  describe "#parse_time" do
    it "parses time with time_date_param" do
      event = Event.new(name: "hi", description: "test event", location: "somewhere", time_date: "08/17/2017 11:00 AM")
      event.save

      expect(event.time_date).to eq("2017-08-17 11:00:00 -0700")
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
      event = Event.new(name: "hi", description: "test event", location: "somewhere", time_date: "08/5/2017 11:00 AM")
      event.save

      expect(event.error_messages).to include("Time & date must be a future event")
    end
  end

  describe "#formatted_time" do
    let(:event2) { create(:event, time_date: "08/5/2021 6:30 PM") }

    it "returns the time_date in a formatted string" do

      expect(event2.formatted_time).to include("6:30 PM on Thursday, August 5, 2021")
    end
  end
end

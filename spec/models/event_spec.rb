require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { create(:event) }

  describe "validate" do
    it "does not allow empty name" do
      event = Event.create(name: "", time_date: Time.now, location: "Address", description: "")

      expect(Event.last).to_not eq(event)
    end

    it "does not allow empty time_date" do
      event = Event.create(name: "Hi", time_date: "", location: "Address", description: "")

      expect(Event.last).to_not eq(event)
    end

    it "does not allow empty location" do
      event = Event.create(name: "Hi", time_date: Time.now, location: "", description: "")

      expect(Event.last).to_not eq(event)
    end

    it "belongs to a user" do
      expect(event.owner.class).to eq(User)
    end
  end

  describe "#parse_time" do
    it "parses time with time_date_param" do
      event = Event.new(name: "hi", description: "test event", location: "somewhere", time_date: "08/17/2017 11:00 AM")
      event.parse_time

      expect(event.time_date).to eq("2017-08-17 11:00:00 -0700")
    end
  end

  describe "#time_date_format" do
    it "validates the format" do
      event = Event.new(name: "hi", description: "test event", location: "somewhere", time_date: "INCORRECT TIME")
      event.parse_time
      event.save

      expect(event.error_messages).to include("Time & Date: Invalid format")
    end
  end
end

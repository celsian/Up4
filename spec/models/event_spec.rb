require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { FactoryGirl.create(:event) }

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
end

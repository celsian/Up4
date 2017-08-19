require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  before(:all) do
    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.add_stub(
      "New York, NY", [
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

    Geocoder::Lookup::Test.add_stub(
      "Vista, CA", [
        {
          'latitude'     => 33.2388149,
          'longitude'    =>  -117.192687,
          'address'      => 'Vista, CA, USA',
          'state'        => 'California',
          'state_code'   => 'CA',
          'country'      => 'United States',
          'country_code' => 'US'
        }
      ]
    )

    Geocoder::Lookup::Test.set_default_stub(
      [
        {
          'latitude'     => 33.1192068,
          'longitude'    => -117.086421,
          'address'      => 'Escondido, CA, USA',
          'state'        => 'California',
          'state_code'   => 'CA',
          'country'      => 'United States',
          'country_code' => 'US'
        }
      ]
    )
  end

  let(:user) { create(:user) }

  before(:each, :sign_in_user) do
    sign_in user
  end

  describe "GET #index" do
    let!(:event1) { create(:event) }
    let!(:event2) { create(:event, :miles_away) }
    let!(:event3) { create(:event, :far_away) }
    let!(:event4) { create(:event, :in_the_past) }
    let(:params_default) { { distance: "10" } }
    let(:params_25_mile) { { distance: "25" } }

    it "returns http success" do
      get :index

      expect(response).to have_http_status(:success)
    end

    it "lists all future events in the area" do
      get :index

      test_events = Event.where("time >= ?", Time.current).near(assigns(:city), params_default[:distance])

      expect(test_events.size).to eq(assigns(:events).size)
    end

    it "lists all future events in the area" do
      get :index, params: params_25_mile

      test_events = Event.where("time >= ?", Time.current).near(assigns(:city), params_25_mile[:distance])

      expect(test_events.size).to eq(assigns(:events).size)
    end
  end

  describe "GET #show" do
    let(:event) { create(:event) }

    it "returns http success" do
      get :show, params: { id: event.id }

      expect(response).to have_http_status(:success)
    end

    it "shows the proper event" do
      get :show, params: { id: event.id }

      expect(assigns(:event)).to eq(event)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new

      expect(response).to have_http_status(:success)
    end

    it "contains a new event object" do
      get :new

      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  describe "GET #edit" do
    let(:event) { create(:event) }
    let(:params) { { id: event.id } }
    it "returns http success" do
      get :edit, params: params

      expect(response).to have_http_status(:success)
    end

    it "contains an existing event object" do
      get :edit, params: params

      expect(assigns(:event)).to eq(event)
      expect(assigns(:event)).to be_persisted
    end
  end

  describe "POST #create" do
    context "user logged in" do
      let(:params) { { event: attributes} }
      let(:attributes) { { name: "hi", location: "somewhere", time_date: (Time.current+3.hours).strftime("%Y-%m-%d %I:%M %p %:z") } }

      it "creates & redirects to event show page", :sign_in_user do
        post :create, params: params

        expect(response).to redirect_to(event_path(assigns(:event)))
      end

      it "has the proper owner", :sign_in_user do
        post :create, params: params

        expect(assigns(:event).users).to include(user)
      end

      it "has the proper time", :sign_in_user do
        post :create, params: params

        expect(assigns(:event).time_date).to eq(attributes[:time_date])
      end
    end
  end

  describe "PATCH #update" do
    context "user logged in" do
      let(:event) { create(:event_with_user) }
      let(:params) { { id: event.id, event: attributes} }
      let(:attributes) { { name: "a new name not used before", location: "somewhere", time_date: (Time.current+4.hours).strftime("%Y-%m-%d %I:%M %p %:z") } }

      it "updates & redirects to event show page", :sign_in_user do
        patch :update, params: params

        expect(response).to redirect_to(event_path(assigns(:event)))
      end

      it "has the same owner", :sign_in_user do
        patch :update, params: params

        expect(assigns(:event).owner).to eq(event.owner)
      end

      it "is the same event", :sign_in_user do
        patch :update, params: params

        expect(assigns(:event).id).to eq(event.id)
      end

      it "has the updated time", :sign_in_user do
        patch :update, params: params

        expect(assigns(:event).time_date).to eq(attributes[:time_date])
      end

      it "has updated name", :sign_in_user do
        patch :update, params: params

        expect(assigns(:event).name).to eq(attributes[:name])
      end
    end
  end
end

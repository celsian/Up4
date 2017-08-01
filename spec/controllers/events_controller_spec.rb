require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user) }

  before(:each, :sign_in_user) do
    sign_in user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index

      expect(response).to have_http_status(:success)
    end

    it "lists all events" do
      get :index
      events = Event.all

      expect(assigns(:events)).to eq(events)
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

  describe "POST #create" do
    context "user logged in" do
      let(:params) { { event: attributes} }
      let(:attributes) { { name: "hi", description: "test event", location: "somewhere", time_date: Time.now+5.hours } }

      it "creates & redirects to event show page", :sign_in_user do
        post :create, params: params

        expect(assigns(:event).users).to include(user)
        expect(response).to redirect_to(event_path(assigns(:event)))
      end
    end
  end
end

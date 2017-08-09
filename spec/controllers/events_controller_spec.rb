require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user) }

  before(:each, :sign_in_user) do
    sign_in user
  end

  describe "GET #index" do
    let!(:event1) { create(:event) }
    let!(:event2) { create(:event, :in_the_past) }

    it "returns http success" do
      get :index

      expect(response).to have_http_status(:success)
    end

    it "lists all future events" do
      get :index

      expect(Event.where("time >= ?", Time.current).count).to eq(assigns(:events).count)
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
end

class EventsController < ApplicationController
  def index
    distance = (params[:distance] || 10).to_i
    @user_location = Geocoder.search(remote_ip).first
    @city = "#{@user_location.data['city']}, #{@user_location.data['region_code']}, #{@user_location.data['country_code']}"
    @events = Event.where("time >= ?", Time.current).near(@city, distance)

    @total_events = Event.all.count
    @total_future_events = Event.where("time >= ?", Time.current).count
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)
    @event.owner = current_user

    if @event.save
      current_user.events << @event
      redirect_to event_path(@event), flash: {success: "Event was created."}
    else
      flash[:error] = "Error: #{@event.error_messages}"
      render :new
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :location, :time_date)
  end
end
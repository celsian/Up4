class EventsController < ApplicationController
  def index
    distance = (params[:distance] || 10).to_i
    @user_location = Geocoder.search(current_user.location).first #This is for pulling location from IP if location doesnt exist, which it should because it's a validation now || Geocoder.search(remote_ip).first
    #This is for partsing IP search results --> @city = "#{@user_location.data['city']}, #{@user_location.data['region_code']}. #{@user_location.data['country_code']}"
    @city = @user_location.data["formatted_address"]
    Time.zone = @user_location.data['time_zone']

    events = Event.where("time >= ?", Time.current).near(@city, distance).reorder("time ASC")
    @events_today = events.where(time: Time.current..Time.current.end_of_day)
    @events_tomorrow = events.where("time >= ?", Time.current.end_of_day)

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

  def update
    @event = Event.find(params[:id])

    # if @event
    if @event.update_attributes(event_params)
      redirect_to event_path(@event), flash: {success: "Event was updated."}
    else
      flash[:error] = "Error: #{@event.error_messages}"
      render :edit
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :location, :time_date)
  end
end
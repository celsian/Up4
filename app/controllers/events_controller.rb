class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.parse_time
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

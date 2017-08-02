class Event < ApplicationRecord
  alias_attribute :owner, :user
  belongs_to :user

  has_many :user_events
  has_many :users, through: :user_events

  validates_presence_of(:name, :time_date, :location)
  #need to validate :time_date is in the proper format (eg Time.now).
  #need to validate :time_date is a future event.

  def error_messages
    messages = ""
    errors.full_messages.each do |message|
      messages += message + ". "
    end
    messages
  end

  def parse_time
    self.time_date = Time.strptime(self.time_date, "%m/%d/%Y %l:%M %p")
  end

end
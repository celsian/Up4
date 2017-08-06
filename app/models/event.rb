class Event < ApplicationRecord
  alias_attribute :owner, :user
  belongs_to :user

  has_many :user_events
  has_many :users, through: :user_events

  validates_presence_of(:name, :location)
  validate :time_date_format
  #need to validate :time_date is a future event.

  def time_date_format
    if time_date == "invalid format"
      errors.add(:base, "Time & Date: Invalid format")
    end
  end

  def parse_time
    begin
      self.time_date = Time.strptime(self.time_date, "%m/%d/%Y %l:%M %p")
    rescue ArgumentError
      self.time_date = "invalid format"
    end
  end

  def error_messages
    messages = ""
    errors.full_messages.each do |message|
      messages += message + ". "
    end

    messages
  end

end
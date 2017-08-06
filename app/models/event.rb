class Event < ApplicationRecord
  before_validation :parse_time

  alias_attribute :owner, :user
  belongs_to :user

  has_many :user_events
  has_many :users, through: :user_events

  validates_presence_of(:name, :location)
  validate :time_date_format
  validate :time_date_future

  def time_date_format
    if time_date == "invalid format"
      errors.add(:base, "Time & date format invalid")
    end
  end

  def time_date_future
    if time_date != "invalid format"
      if time_date.to_time < Time.now
        errors.add(:base, "Time & date must be a future event")
      end
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
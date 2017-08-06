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
    if self.time_date != nil
      unless self.time_date[-2..-1] == "00" || self.time_date[-2..-1] == "30" #If time_date is a Time object already, do nothing.
        begin #convert time_date to Time object if possible
          self.time_date = Time.strptime(self.time_date, "%m/%d/%Y %l:%M %p")
        rescue ArgumentError #otherwise catch and set time_date to invalid format.
          self.time_date = "invalid format"
        end
      end
    else #if time_date is nil set it to invalid format
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
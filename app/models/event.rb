class Event < ApplicationRecord
  before_validation :time_update

  alias_attribute :owner, :user
  belongs_to :user

  has_many :user_events
  has_many :users, through: :user_events

  validates_presence_of(:name, :location)
  validate :time_date_format
  validate :time_date_future

  TIME_DATE_PATTERN = /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}) [AP]M [-+](\d{2}):(\d{2})/

  def time_date_format
    unless Event::TIME_DATE_PATTERN.match?(self.time_date)
      errors.add(:base, "Time & date format invalid")
    end
  end

  def time_date_future
    unless errors[:base].length > 0
      if time_date.to_time < Time.current
        errors.add(:base, "Time & date must be a future event")
      end
    end
  end

  def time_update
    self.time = self.time_date.to_time
  end

  def formatted_time
    format_first = time_date.to_time.strftime("%l:%M %p on %A, %B %-d, %Y %z")
  end

  def error_messages
    messages = ""
    errors.full_messages.each do |message|
      messages += message + ". "
    end

    messages
  end

end
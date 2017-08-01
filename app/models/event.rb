class Event < ApplicationRecord
  alias_attribute :owner, :user
  belongs_to :user

  has_many :user_events
  has_many :users, through: :user_events

  validates_presence_of(:name, :time_date, :location)

  def error_messages
    messages = ""
    errors.full_messages.each do |message|
      messages += message + "."
    end
    messages
  end

end

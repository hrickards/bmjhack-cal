class WaitlistAppointment < ActiveRecord::Base
  belongs_to :waitlist_user, class_name: :User, foreign_key: :user_id
  belongs_to :waitlist_event, class_name: :Event, foreign_key: :event_id
end

class AddTimestampToEventsController < ActiveRecord::Migration
  def change
    add_column :waitlist_appointments, :timestamp, :datetime
  end
end

class CreateWaitlistAppointments < ActiveRecord::Migration
  def change
    create_table :waitlist_appointments do |t|
      t.belongs_to :event
      t.belongs_to :user
    end
  end
end

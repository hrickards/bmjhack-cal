class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.belongs_to :user
      t.belongs_to :event
    end
  end
end

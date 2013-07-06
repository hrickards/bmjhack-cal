class UpdateEventSchema < ActiveRecord::Migration
  def change
    drop_table :events

    create_table :events do |t|
      t.string :title
      t.string :location
      t.string :teacher
      t.integer :limit
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.text :resources

      t.timestamps
    end
  end
end

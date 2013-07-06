class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.integer :list
      t.datetime :date

      t.timestamps
    end
  end
end

class UpdateUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :name
      t.string :year
      t.string :course
    end
  end
end

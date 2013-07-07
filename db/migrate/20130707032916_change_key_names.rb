class ChangeKeyNames < ActiveRecord::Migration
  def change
    rename_column :users, :course, :courses
    rename_column :users, :year, :years
  end
end

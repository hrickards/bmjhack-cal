class CreateKeywords < ActiveRecord::Migration
  def change
    add_column :events, :keywords, :string
  end
end

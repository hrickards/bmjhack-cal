class AddAdmin < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :administrator, :default => false
    end
  end
end

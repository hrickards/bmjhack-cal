class Event < ActiveRecord::Base
  attr_accessible :title, :description, :limit, :date, :tags
  has_many :appointments, dependent: :destroy
  has_many :users, through: :appointments
  
  acts_as_taggable_on :tags
end

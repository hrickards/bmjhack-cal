class Event < ActiveRecord::Base
  attr_accessible :title, :location, :teacher, :limit, :course, :year, :start_datetime, :end_datetime, :resources, :tags

  has_many :appointments, dependent: :destroy
  has_many :users, through: :appointments

  has_many :waitlist_appointments, dependent: :destroy
  has_many :waitlist_users, through: :waitlist_appointments, foreign_key: :event_id, class_name: :User
  
  acts_as_taggable_on :tags, :course, :year

  after_update :email_changes
  after_update :check_waitlist

  def check_waitlist
    if self.users.count < self.limit and self.waitlist_users.count > 0
      user = self.waitlist_users.find(:all, :order => "timestamp ASC").first
      self.waitlist_users.delete(user)
      self.users.append(user)
      UserMailer.off_waitlist_email(user, self).deliver
    end
  end

  def send_email_group(subject, message)
    self.users.each do |user|
      UserMailer.send_email_group(user, subject, message).deliver
    end
  end

  #http://murmurinfo.wordpress.com/2010/11/26/ical-support-for-rails/
  def ical
    e = Icalendar::Event.new
    e.uid = self.id
    e.dtstart = self.start_datetime
    e.dtend = self.end_datetime
    e.summary = self.title
    e.created = self.created_at
    e.location = self.location
    
    e
  end

  private
  def get_changes
    old_attributes = {'title'=>self.title_was, 'location'=>self.location_was, 'teacher'=>self.teacher_was, 'start_datetime'=>self.start_datetime_was, 'end_datetime'=>self.end_datetime_was, 'resources'=>self.resources_was}
    changes = {}
    self.attributes.each_pair do |key, val|
      unless old_attributes[key] == val or key == "created_at" or key == "updated_at" or key == "id" or not old_attributes.include? (key)
        changes[key] = {old: old_attributes[key], new: val}
      end
    end
    return changes
  end

  def email_changes
    changes = get_changes
    unless changes.empty?
      for user in self.users do
        UserMailer.changes_email(user, self, changes).deliver
      end
    end
  end
end

class Event < ActiveRecord::Base
  attr_accessible :title, :description, :limit, :date, :tags

  has_many :appointments, dependent: :destroy
  has_many :users, through: :appointments

  has_many :waitlist_appointments, dependent: :destroy
  has_many :waitlist_users, through: :waitlist_appointments, foreign_key: :event_id, class_name: :User
  
  acts_as_taggable_on :tags

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

  private
  def get_changes
    old_attributes = {'title'=>self.title_was, 'description'=>self.description_was, 'limit'=>self.limit_was, 'date'=>self.date_was}
    changes = {}
    self.attributes.each_pair do |key, val|
      unless old_attributes[key] == val or key == "created_at" or key == "updated_at" or key == "id"
        changes[key] = {old: old_attributes[key], new: val}
      end
    end
    return changes
  end

  def email_changes
    for user in self.users do
      UserMailer.changes_email(user, self, get_changes).deliver
    end
  end
end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :course, :year, :administrator

  has_many :appointments, dependent: :destroy
  has_many :events, through: :appointments

  has_many :waitlist_appointments, dependent: :destroy
  has_many :waitlist_events, through: :waitlist_appointments, foreign_key: :user_id, class_name: :Event

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
        user = User.create(name: data["name"],
             email: data["email"],
             password: Devise.friendly_token[0,20],
             administrator: false
            )
    end
    user
  end
end

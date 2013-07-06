class UserMailer < ActionMailer::Base
  default from: "hrickards@gmail.com"

  def changes_email(user, event, differences)
    @user = user
    @event = event
    @differences = differences

    mail to: @user.email, subject: 'Changes made to event'
  end
end

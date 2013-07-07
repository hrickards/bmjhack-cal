class UserMailer < ActionMailer::Base
  default from: "hrickards@gmail.com"

  def changes_email(user, event, differences)
    @user = user
    @event = event
    @differences = differences

    mail to: @user.email, subject: 'Changes made to event'
  end

  def off_waitlist_email(user, event)
    @user = user
    @event = event

    mail to: @user.email, subject: 'Off waitlist for event'
  end

  def send_email_group(user, subject, message)
    @user = user
    @subject = subject
    @message = message

    mail to: @user.email, subject: @subject
  end
end

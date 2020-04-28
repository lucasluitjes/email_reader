require 'mailgun-ruby'

class UserMailer < ApplicationMailer

  default from: ENV.fetch("FROM_ADDRESS")

  def h_newsletter_notification
    email = ENV.fetch("NOTIFICATION_ADDRESS")
    subject= "New hacker newsletter received"
    text = "Check email-reader"
    mail to: email, subject: subject, body: text
  end
end

require 'mailgun-ruby'

class UserMailer < ApplicationMailer

  default from: "email-overview@luitjes.it"

  def email_overview
    email = "lucas@luitjes.it"
    unread_mails_past_week = generate_weekly_overview
    subject= "mail received last week"
    text = "Past week you received emails from: #{unread_mails_past_week}"
    mail to: email, subject: subject, body: text
  end

  private

  def generate_weekly_overview
    last_week = Time.now - 7
    unread_mails = Email.select { |email| !email.read && email.created_at > last_week }
    unread_mails.map { |email| Mail.new(email.body)[:from].display_names.first }
  end
end

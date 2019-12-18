class UserMailer < ApplicationMailer

  def initialize
    super
    if Rails.env == "production"
      default from: "lucas@luitjes.it"
    end
  end

  def email_overview
    email = "lucas@luitjes.it"
    unread_mails_past_week = generate_weekly_overview
    subject = "Past week you received emails from: #{unread_mails_past_week}"
    mail to: email, subject: subject
  end

  private

  def generate_weekly_overview
    last_week = Time.now - 7
    unread_mails = Email.select { |email| !email.read && email.created_at > last_week }
    unread_mails.map { |email| Mail.new(email.body)[:from].display_names.first }
  end
end

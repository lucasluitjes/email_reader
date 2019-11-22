class UserMailer < ApplicationMailer
  def email_overview
    email = "lucas@luitjes.test"
    subject = "" # Email.generate_weekly_overview
    mail to: email, subject: subject
    puts "email sent"
  end
end
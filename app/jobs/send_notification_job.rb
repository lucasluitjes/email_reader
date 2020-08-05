# frozen_string_literal: true

class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(email)
    if email.sender == Email::Symbols.invert[:hacker_newsletter]
      UserMailer.h_newsletter_notification.deliver_now
    end
  end
end

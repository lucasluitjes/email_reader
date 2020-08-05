# frozen_string_literal: true

require 'mail'

class IncomingEmailsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  def create
    mail = Mail.new(params[:message])

    email = Email.create(
      sender: mail.from,
      subject: mail.subject,
      body: params[:message]
    )

    SendNotificationJob.perform_later(email)
    CreateLinksJob.perform_later(email)
    render text: 'OK'
  end
end

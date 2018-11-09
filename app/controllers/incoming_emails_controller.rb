require 'mail'

class IncomingEmailsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create
  def create
    mail = Mail.new(params[:message])

    Email.create(
      sender: mail.from,
      subject: mail.subject,
      body: mail.body
      )

    render text: "OK"
  end
end
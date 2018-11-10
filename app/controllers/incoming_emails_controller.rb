require 'mail'

class IncomingEmailsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  def create
    mail = Mail.new(params[:message])

    Email.create(
      sender: mail.from,
      subject: mail.subject,
      body: params[:message]
      )

    render text: "OK"
  end
end
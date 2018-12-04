require 'mail'

class IncomingEmailsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  def create
    mail = Mail.new(params[:message])

    doc = Nokogiri::HTML.parse(mail.html_part.body.raw_source) rescue nil
    if doc&.xpath("html/body/div/text()")&.map(&:text)&.include?("This week's database news")
      process_dbweekly(doc)
    end

    Email.create(
      sender: mail.from,
      subject: mail.subject,
      body: params[:message]
      )

    render text: "OK"
  end

  private

  def process_dbweekly(doc)
    binding.pry
  end
end
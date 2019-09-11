class CreateLinksJob < ApplicationJob
  queue_as :default

  def perform(email)
    email.create_links! 
  end
end

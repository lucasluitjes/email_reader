# frozen_string_literal: true

desc 'This task is called by the Heroku scheduler add-on'
task email_overview: :environment do
  UserMailer.email_overview.deliver if Time.now.wday == 5 && Time.now.hour > 15
end

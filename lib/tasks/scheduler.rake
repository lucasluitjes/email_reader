require 'mailgun-ruby'

desc "This task is called by the Heroku scheduler add-on"
task :email_overview => :environment do
  if (!(DateTime.parse(Overview.last_overview?.to_s).today?) && Time.now.wday == 5 && Time.now.hour > 15)
    mailer_response = UserMailer.email_overview.deliver
    mailgun_message_id = mailer_response.message_id
    puts "mail: #{mailgun_message_id} delivered"
    Overview.update_last_overview
  end
end

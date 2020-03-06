

desc "This task is called by the Heroku scheduler add-on"
task :email_overview => :environment do
  if (Time.now.wday == 5 && Time.now.hour > 15)
    UserMailer.email_overview.deliver
  end
end

desc "This task is called by the Heroku scheduler add-on"
task :email_overview => :environment do
  if (!Email.last_overview?.today?)
    UserMailer.email_overview.deliver
    puts "------------- delivered mail"
    Email.update_last_overview
  end
end

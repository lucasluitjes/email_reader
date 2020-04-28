class SendNotificationJobTest < ActiveJob::TestCase
  setup do
    file = File.read("test/fixtures/files/Hacker Newsletter #434.eml")
    mail = Mail.new(file)
    @email = Email.create(
      sender: mail.from.first,
      subject: mail.subject,
      body: mail.body
      )
  end

  test "should send a notification email when a hacker newsletter is received" do
    assert_difference('ActionMailer::Base.deliveries.size') do       
      SendNotificationJob.perform_now(@email)
    end
  end
end

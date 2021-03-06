# frozen_string_literal: true

require 'test_helper'
require 'mail'
require 'pp'

class EmailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'it parses the email list type' do
    # email = Email.new(body: File.read("test/fixtures/files/dbweekly.txt"))
    # assert_equal :db_weekly, email.email_list_type
    email_list_type = Email.new(body: File.read('test/fixtures/files/java_weekly.eml')).email_list_type
    assert_equal :java_weekly, email_list_type
    email_list_type = Email.new(body: File.read('test/fixtures/files/breaking_smart.eml')).email_list_type
    assert_equal :breaking_smart, email_list_type
    email_list_type = Email.new(body: File.read('test/fixtures/files/elixir_weekly.eml')).email_list_type
    assert_equal :elixir_weekly, email_list_type
    email_list_type = Email.new(body: File.read("test/fixtures/files/Hacker\ Newsletter\ \#434.eml")).email_list_type
    assert_equal :hacker_newsletter, email_list_type
    email_list_type = Email.new(body: File.read('test/fixtures/files/ruby_weekly.eml')).email_list_type
    assert_equal :ruby_weekly, email_list_type
    email_list_type = Email.new(body: File.read("test/fixtures/files/SRE\ Weekly\ Issue\ \#154.eml")).email_list_type
    assert_equal :sre_weekly, email_list_type
    email_list_type = Email.new(body: File.read('test/fixtures/files/vulnerabilities.eml')).email_list_type
    assert_equal :vulnerabilities, email_list_type
    email_list_type = Email.new(body: File.read('test/fixtures/files/blendle.eml')).email_list_type
    assert_equal :blendle, email_list_type
    email_list_type = Email.new(body: File.read("test/fixtures/files/The\ CloudSecList.eml")).email_list_type
    assert_equal :cloud_sec, email_list_type
  end

  test 'grab text from cloudSecList' do
    email = Email.new(body: File.read("test/fixtures/files/The\ CloudSecList.eml"))
    urls = email.cloud_sec_links
    assert_equal ["The undetectable way of exporting an AWS DynamoDB", " This post describes a limitation in the current AWS CloudTrail logging features that limit detection capabilities of possible abuse against AWS DynamoDB, in the event of the user's AWS IAM keys being compromised. In particular, CloudTrail doesn't currently record any scanning/reading of a DynamoDB table through awscli.", "https://blog.3coresec.com/2020/04/the-undetectable-way-of-exporting-aws.html"], urls[0]
    assert_equal 18, urls.size
  end

  test 'parse links correctly from cloudSecList' do
    email = Email.new(body: File.read("test/fixtures/files/cloudseclistLinkParsingProblem.eml"))
    urls = email.cloud_sec_links
    assert_equal ["Introducing Policy As Code: The Open Policy Agent (OPA)", " CNCF deep-dive series on how to use Open Policy Agent to unify security policy enforcement across your entire set of Kubernetes clusters.", "https://www.cncf.io/blog/2020/08/13/introducing-policy-as-code-the-open-policy-agent-opa/"], urls[0]
    assert_equal 27, urls.size
  end

  test 'parse descriptions correctly from cloudSecList' do
    email = Email.new(body: File.read("test/fixtures/files/cloudseclist_parse_problem.eml"))
    urls = email.cloud_sec_links
    assert_equal ["Offensive Terraform Modules", " #aws, #attack Collection of (automated) offensive attack modules defined as Infrastructure as Code (IAC).", "https://offensive-terraform.github.io/"], urls[4]
    assert_equal 36, urls.size
  end

  test 'grab text from db_weekly' do
    email = Email.new(body: File.read('test/fixtures/files/dbweekly.txt'))
    urls = email.db_weekly_links
    assert_equal ['Redis Speeds Towards a Multi-Model Future',
                  'Redis is best known as a very fast key-value store, but there’s more to it than that especially if Redis Labs gets its way. Here’s an update on where Redis is at right now.',
                  'https://dbweekly.com/link/53785/85a4c1edbc'], urls[1]
    assert_equal 15, urls.size
  end

  test 'grab text from java_weekly' do
    email = Email.new(body: File.read('test/fixtures/files/java_weekly.eml'))
    urls = email.java_weekly_links
    assert_equal ["RunJS: A JavaScript 'Scratchpad' Tool for macOS", 'Write and run JavaScript instantly. Useful for learning, experimenting, or perhaps even creating screencasts, tweets, or similar educational content.', 'https://javascriptweekly.com/link/57608/4068a3c669'], urls[0]
    assert_equal 30, urls.size
  end

  test 'grab text from breaking smart' do
    email = Email.new(body: File.read('test/fixtures/files/breaking_smart.eml'))
    url = email.breaking_smart_links
    assert_equal ['breaking smart link', 'view this email in your browser', 'https://mailchi.mp/ribbonfarm/good-afternoon-internet-im-listening?e=4c5a41c2ff'], url
  end

  test 'grab text from elixir weekly' do
    email = Email.new(body: File.read('test/fixtures/files/elixir_weekly.eml'))
    urls = email.elixir_weekly_links
    assert_equal 22, urls.size
  end

  test 'grab text from hacker newsletter' do
    email = Email.new(body: File.read("test/fixtures/files/Hacker\ Newsletter\ \#434.eml"))
    urls = email.hacker_newsletter_links
    assert_equal ['Algorithms, by Jeff Erickson', '//illinois comments→',
                  'https://hackernewsletter.us1.list-manage.com/track/click?u=faa8eb4ef3a111cef92c4f3d4&id=56ee376af8&e=16cfb65b5e'], urls[0]
    assert_equal 56, urls.size
  end

  test 'grab text from ruby weekly' do
    email = Email.new(body: File.read('test/fixtures/files/ruby_weekly.eml'))
    urls = email.ruby_weekly_links
    assert_equal ['Ruby 2.6 Released',
                  'Ruby 2.6 Released — As is traditional, the latest major release of Ruby came out on Christmas Day. The much awaited 2.6 includes an initial implementation of a JIT compiler (which needs to be enabled manually), the then alias for yield_self, RubyVM::AbstractSyntaxTree, endless ranges, and a lot more (see next item).',
                  'https://rubyweekly.com/link/57534/d218cfa36e'], urls[0]
    assert_equal 27, urls.size
  end

  test 'ruby weekly parsing problem' do
    email = Email.new(body: File.read('test/fixtures/files/RubyWeeklyParsingProblem.eml'))
    urls = email.ruby_weekly_links
    assert_equal ["The State of Ruby 3 Typing: Introducing RBS", "The State of Ruby 3 Typing: Introducing RBS — Back in May we mentioned RBS, a language being used for type signatures in Ruby programs, but this is a much more accessible introduction to the concepts around it. RBS and the tooling around it will ship with the eventual Ruby 3.", "https://rubyweekly.com/link/92700/8e2498409f"], urls[0]
    assert_equal 24, urls.size
  end

  test 'grab text from sre weekly' do
    email = Email.new(body: File.read("test/fixtures/files/SRE\ Weekly\ Issue\ \#154.eml"))
    urls = email.sre_weekly_links
    assert_equal ['STAMPing on event-stream Hands-down the best thing I’ve read in awhile! The author draws on the work of Nancy Leveson, applying her STAMP theory to a recent incident involving a rogue NPM package that stole bitcoin wallets. Hillel Wayne ',
                  ' ', 'https://www.hillelwayne.com/post/stamping-on-eventstream/'], urls[0]
    assert_equal 11, urls.size
  end

  test 'grab text from vulnerabilities newsletter' do
    email = Email.new(body: File.read('test/fixtures/files/vulnerabilities.eml'))
    urls = email.vulnerabilities_links
  end

  test 'grab text from blendle' do
    email = Email.new(body: File.read('test/fixtures/files/blendle.eml'))
    urls = email.blendle_links
    assert_equal 14, urls.size
  end

  test 'grab text from tactical tech' do
    email = Email.new(body: File.read('test/fixtures/files/tactical_tech.eml'))
    urls = email.tactical_tech_links
    assert_equal 31, urls.size
  end
end

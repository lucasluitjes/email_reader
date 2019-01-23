require 'test_helper'
require 'mail'
require 'pp'

class EmailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "grab text from db_weekly" do
  	email = Email.new(body: File.read("test/fixtures/files/dbweekly.txt"))
    urls = email.db_weekly_links
    assert_equal ["Redis Speeds Towards a Multi-Model Future",
 "Redis is best known as a very fast key-value store, but there’s more to it than that especially if Redis Labs gets its way. Here’s an update on where Redis is at right now.",
 "https://dbweekly.com/link/53785/85a4c1edbc"], urls[1]
 assert_equal 18, urls.size
  end

  test "grab text from java_weekly" do
    email = Email.new(body: File.read("test/fixtures/files/java_weekly.eml"))
    urls = email.java_weekly_links
    # assert_equal [], urls[1]
  end
  test "grab text from breaking smart" do
    email = Email.new(body: File.read("test/fixtures/files/breaking_smart.eml"))
    url = email.breaking_smart_link
    assert_equal ["View this email in your browser", "https://mailchi.mp/ribbonfarm/good-afternoon-internet-im-listening?e=4c5a41c2ff"], url
    assert_equal 1, url.size
  end

  test "grab text from elixir weekly" do
    email = Email.new(body: File.read("test/fixtures/files/elixir_weekly.eml"))
    urls = email.elixir_weekly_links
    assert_equal 22, urls.size
  end

  test "grab text from hacker newsletter" do
    email = Email.new(body: File.read("test/fixtures/files/Hacker\ Newsletter\ \#434.eml"))
    urls = email.hacker_newsletter_links
  end

  test "grab text from blendle" do
    email = Email.new(body: File.read("test/fixtures/files/blendle.eml"))
    urls = email.blendle_links
  end
end

# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
bodies = ['test/fixtures/files/dbweekly.txt', 'test/fixtures/files/java_weekly.eml', 'test/fixtures/files/breaking_smart.eml', 'test/fixtures/files/elixir_weekly.eml', "test/fixtures/files/Hacker\ Newsletter\ \#434.eml", 'test/fixtures/files/ruby_weekly.eml', "test/fixtures/files/SRE\ Weekly\ Issue\ \#154.eml", 'test/fixtures/files/vulnerabilities.eml', 'test/fixtures/files/blendle.eml', 'test/fixtures/files/RubyWeeklyParsingProblem.eml', 'test/fixtures/files/cloudseclistLinkParsingProblem.eml']

bodies.each do |body|
  email = Email.create(body: File.read(body))
  email.create_links!
end

Dir['test/fixtures/files/more-samples/*.eml'].each do |path|
  email = Email.create(body: File.read(path))
  email.create_links!
end

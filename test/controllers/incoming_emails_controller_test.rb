# frozen_string_literal: true

require 'test_helper'

class IncomingEmailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # @email = emails(:one)
  end

  test 'should create email' do
    assert_difference('Email.count') do
      post incoming_emails_url, params: { message: File.read('test/fixtures/files/dbweekly.txt') }
    end
  end
end

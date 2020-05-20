# frozen_string_literal: true

json.extract! email, :id, :sender, :read, :subject, :body, :created_at, :updated_at
json.url email_url(email, format: :json)

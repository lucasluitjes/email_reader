# frozen_string_literal: true

Rails.application.routes.draw do
  resources :emails
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'incoming_emails' => 'incoming_emails#create'
end

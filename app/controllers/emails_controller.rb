# frozen_string_literal: true

class EmailsController < ApplicationController
  before_action :set_email, only: %i[show edit update destroy download_eml]

  if Rails.env == 'production'
    username = ENV['BASIC_USERNAME']
    password = ENV['BASIC_PASSWORD']
    unless username.present? && password.present?
      raise 'Total brutal lack of configuration, security kitty is not pleased :('
    end

    http_basic_authenticate_with name: username, password: password
  end

  # GET /emails
  # GET /emails.json
  def index
    @emails = Email.order('created_at DESC').page(params[:page]).per(10)
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
    mail = Mail.new(@email.body)
    body = mail.html_part || mail.text_part || mail
    render html: body.decoded.html_safe
  end

  # GET /emails/new
  def new
    @email = Email.new
  end

  # GET /emails/1/edit
  def edit; end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new(email_params)

    respond_to do |format|
      if @email.save
        format.html { redirect_to @email, notice: 'Email was successfully created.' }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'Email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /emails/1/download_eml
  def download_eml
    send_data(@email.body, filename: "#{@email.id}.eml", disposition: "attachment")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_email
    @email = Email.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def email_params
    params.require(:email).permit(:sender, :read, :subject, :body)
  end
end

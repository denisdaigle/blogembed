class ConnectionsController < ApplicationController
  
  def connect
    
    #Add to MailChimp list.
    
    #Set access to key based on environment.
    @mailchimp_key = ""
    if Rails.env == "production"
      @mailchimp_key = ENV['MAILCHIMP_KEY']
    else
      @mailchimp_key = Rails.application.secrets.mailchimp_key
    end
    
    client = Mailchimp::API.new(@mailchimp_key)
  
    begin
      sub_single_user = client.lists.subscribe('2e13e45505', {email: params[:email]})
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
    else
      # other exception
    ensure
      # always executed
    end
    
    #Email to visitor
    @recipient_name1 = "new signup"
    @recipient_email1 = "denis@blogembed.com"
    @subject1 = "Hey Denis, you have a new guest"
    @body1 = "Hey Denis, #{params[:email]} has asked to be part of this thing!"
    GeneralMailer.general_email(@recipient_name1, @recipient_email1, @subject1, @body1).deliver

  end
  
end

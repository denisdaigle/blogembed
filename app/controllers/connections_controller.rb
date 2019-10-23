class ConnectionsController < ApplicationController
  
  def connect
    
    #Email to visitor
    @recipient_name = ""
    @recipient_email = params[:email]
    @subject = "Thanks for reaching out on blogembed.com!"
    @body = "Hello, thanks for your interest in blogembed.com, you're on the list to be notified when blogembed.com is ready to use."
    GeneralMailer.general_email(@recipient_name, @recipient_email, @subject, @body).deliver
    
    #Email to me about new visitor.
    @recipient_name = "New Visitor"
    @recipient_email = "denis@blogembed.com"
    @subject = "You have a new blogembed.com visitor"
    @body = "Hello, #{params[:email]} has asked to be part of this service."
    GeneralMailer.general_email(@recipient_name, @recipient_email, @subject, @body).deliver
    
  end
  
end

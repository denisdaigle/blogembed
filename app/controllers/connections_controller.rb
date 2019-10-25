class ConnectionsController < ApplicationController
  
  def connect
    
    #Email to me about new visitor.
    @recipient_name = "New Visitor"
    @recipient_email = params[:email] 
    @subject = "Thanks for signing up for BlogEmbed!"
    @body = "Hello, thanks for signing up for BlogEmbed. We're not quite ready for show time yet, but when we are, we'll let you know how to get started!"
    GeneralMailer.general_email(@recipient_name, @recipient_email, @subject, @body).deliver

    #Email to visitor
    @recipient_name1 = "signup"
    @recipient_email1 = "denis@blogembed.com"
    @subject1 = "Hey Denis, you have a new guest"
    @body1 = "Hey Denis, #{params[:email]} has asked to be part of this thing!"
    GeneralMailer.general_email(@recipient_name1, @recipient_email1, @subject1, @body1).deliver

  end
  
end

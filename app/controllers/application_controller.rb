class ApplicationController < ActionController::Base
    
    before_action :check_for_broadcast
    
    def check_for_broadcast
       #Turn the message into a variable if it was provided with a request.    
       if params[:broadcast_message].present?
          @broadcast_message = params[:broadcast_message]
       end       
    end    
    
end

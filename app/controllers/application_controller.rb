class ApplicationController < ActionController::Base
    
    # before_action :check_for_broadcast
    
    # def check_for_broadcast
    #   #Turn the message into a variable if it was provided with a request.    
    #   if params[:broadcast_message].present?
    #       @broadcast_message = params[:broadcast_message]
    #   end       
    # end    
    
    def ask
       
        @question = params[:q]
      
        #Resulting HTML file from setup save attempt.
        respond_to do |format|
            format.js { render action: 'yes_no_popup' }
        end
        
    end    
    
end

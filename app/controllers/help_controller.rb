class HelpController < ApplicationController
    
    def ask_for_help
        #will render ask_for_help.html.erb
    end    
    
    def send_for_help
        
        #error check if email was provided.
        if params[:question_type].present? && params[:question].present? && params[:email].present?

    	  #build the query to send to the API server    
          query = {:question_type => params[:question_type], :question => params[:question], :email => params[:email]}
    
          #Grab the variables for this connection from the secrets.yml file.
          headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
          
          #Use HTTParty with the address for the API server direftly (and load balancer in production) to a /v1/send_for_help service on the API.
          send_for_help_call = HTTParty.post(
            Rails.configuration.access_point['api_domain'] + '/v1/send_for_help.json', 
            :query => query,
            :headers => headers
          )
          
          @result = send_for_help_call["result"]
          @message = send_for_help_call["message"] #Message comes from the API to help with future I18n multilingualism.
    
          #ITTT result.
          if @result == "success"
              
              @success_message = @message + " Expect a reply between 8am - 6:30pm Atlantic Time Monday through Friday."
    
          else
          
              if @message.present?
                  @error_message = @message
              else
                  @error_message = "Sorry, there was an error sending this message."
              end  
          
          end
          
        else
           
            @error_message = "Seems like you're missing some form data. Please have a look."
            
        end
    
        #Resulting JS file and action post sign-up attempt.
        respond_to do |format|
          format.js { render action: 'send_for_help_results' }
        end
        
    end
    
end

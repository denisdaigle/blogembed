class ConnectionsController < ApplicationController
  
  def connect
    
    #error check if email was provided.
    if params[:email].present?
	       
	   #build the query to send to the API server    
      query = {:email => params[:email]}

      #Grab the variables for this connection from the secrets.yml file.
      headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
      
      #Use HTTParty with the address for the API server direftly (and load balancer in production) to a /v1/sign_up service on the API.
      sign_up_user = HTTParty.post(
        Rails.configuration.access_point['api_domain'] + '/v1/sign_up.json', 
        :query => query,
        :headers => headers
      )
      
      @result = sign_up_user["result"]
      @message = sign_up_user["message"] #Message comes from the API to help with future I18n multilingualism.

      #ITTT result.
      if @result == "success"
          
          @next_step_message = @message 

      else
      
          if @message.present?
              @error_message = @message
          else
              @error_message = "Sorry, there was an error completing your sign-up."
          end  
      
      end
      
    else
       
        @error_message = "The server did not receive an email address? Please provide an email address."
        
    end

    #Resulting JS file and action post sign-up attempt.
    respond_to do |format|
      format.js { render action: 'sign_up_results' }
    end
        
  end     
  
end

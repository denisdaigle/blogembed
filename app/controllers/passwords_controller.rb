class PasswordsController < ApplicationController
  
  def request_reset_password_link
    #will render request_reset_password_link.html.erb
  end
  
  def process_password_reset_link_request
    #error check if email was provided
    if params[:email].present?
	       
        #build the query to send to the API server    
        query = {:email => params[:email]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/process_request_reset_password_link service on the API.
        process_request_reset_password_link = HTTParty.post(
            Rails.configuration.access_point['api_domain'] + '/v1/process_request_reset_password_link.json', 
            :query => query,
            :headers => headers
        )
        
        @result = process_request_reset_password_link["result"]
        @message = process_request_reset_password_link["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = process_request_reset_password_link["payload"]

        #ITTT result.
        if @result == "success"
          
            @success_message = @message
            
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error processing your password reset request information."
            end  
        
        end
      
    else
       
        @error_message = "Looks like you are missing your log in email address. Please have a look."
        
    end

    #Resulting js file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'request_reset_password_link_results' }
    end
    
  end  
  
  def create_new_password
    #will render create_new_password.html.erb
  end  
  
  def process_new_password
    
    #error check if password was provided
    if params[:password].present?
	       
        #build the query to send to the API server    
        query = {:password => params[:password], :password_reset_code => params[:password_reset_code]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/process_new_password service on the API.
        process_new_password_call = HTTParty.post(
            Rails.configuration.access_point['api_domain'] + '/v1/process_new_password.json', 
            :query => query,
            :headers => headers
        )
        
        @result = process_new_password_call["result"]
        @message = process_new_password_call["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = process_new_password_call["payload"]

        #ITTT result.
        if @result == "success"
          
            #Create cookie that expires in 24hrs 
            cookies[:db_session_token] = { value: @payload["db_session_token"], expires: 1.day }
            
            @broadcast_message = @message

        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error processing your new password."
            end  
        
        end
      
    else
       
        @error_message = "Looks like you are missing a new password. Please have a look."
        
    end

    #Resulting js file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'process_new_password_results'}
    end
    
  end  
  
end

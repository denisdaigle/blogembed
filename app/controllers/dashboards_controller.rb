class DashboardsController < ApplicationController
  
  before_action :check_db_session_token
  
  def check_db_session_token
    
    #error check if email was provided.
    if cookies[:db_session_token].present?
	       
	   #build the query to send to the API server    
      query = {:db_session_token => cookies[:db_session_token]}

      #Grab the variables for this connection from the secrets.yml file.
      headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
      
      #Use HTTParty with the address for the API server direftly (and load balancer in production) to a /v1/check_db_session_token service on the API.
      check_db_session_token_call = HTTParty.get(
        Rails.configuration.access_point['api_domain'] + '/v1/check_db_session_token.json', 
        :query => query,
        :headers => headers
      )
      
      @result = check_db_session_token_call["result"]
      @message = check_db_session_token_call["message"] #Message comes from the API to help with future I18n multilingualism.

      #ITTT result.
      if @result == "success"
          
          #allow through

      else
      
          #delete cookie, redirect to login.
          cookies.delete :db_session_token
          
          #handle html or js
          respond_to do |format|
            format.js { render action: '../users/refresh_to_login' }
            format.html { render action: '../users/login' }
          end
      
      end
      
    else
       
        #delete cookie, redirect to login.
        cookies.delete :db_session_token
        
        #handle html or js
        respond_to do |format|
          format.js { render action: '../users/refresh_to_login' }
          format.html { render action: '../users/login' }
        end
        
    end

  end  
  
  def dashboard
    #will render automatically
  end
end

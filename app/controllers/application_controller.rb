class ApplicationController < ActionController::Base
    
    before_action :check_account_type
  
    def check_account_type
      
        #error check if email was provided.
        if cookies[:db_session_token].present?
    	       
    	    #build the query to send to the API server    
            query = {:db_session_token => cookies[:db_session_token]}
              
            #Grab the variables for this connection from the secrets.yml file.
            headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
            
            #Use HTTParty with the address for the API server direftly (and load balancer in production) to a /v1/check_db_session_token service on the API.
            check_account_type = HTTParty.get(
              Rails.configuration.access_point['api_domain'] + '/v1/check_account_type.json', 
              :query => query,
              :headers => headers
            )
            
            @result = check_account_type["result"]
            @message = check_account_type["message"] #Message comes from the API to help with future I18n multilingualism.
            @payload = check_account_type["payload"]
        
            #ITTT result.
            if @result == "success"
                
              @account_type = @payload["account_type"]
            
            end

        end
    
    end  
    
    def ask
       
        @question = params[:q]
        @action = params[:a]
      
        #Resulting HTML file from setup save attempt.
        respond_to do |format|
            format.js { render action: 'yes_no_popup' }
        end
        
    end
    
    def inform
       
        @info = params[:i]
      
        #Resulting HTML file from setup save attempt.
        respond_to do |format|
            format.js { render action: 'info_popup' }
        end
        
    end
    
end

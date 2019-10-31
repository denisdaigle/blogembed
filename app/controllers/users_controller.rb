class UsersController < ApplicationController
    
    def sign_up
        
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
    
    def confirm_account
    
        #error check if sign_up_code was provided
        if params[:sign_up_code].present?
    	       
            #build the query to send to the API server    
            query = {:sign_up_code => params[:sign_up_code]}
            
            #Grab the variables for this connection from the secrets.yml file.
            headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
            
            #Use HTTParty with the address for the API server direftly (and load balancer in production) to a /v1/sign_up service on the API.
            validate_sign_up_code = HTTParty.get(
                Rails.configuration.access_point['api_domain'] + '/v1/validate_sign_up_code.json', 
                :query => query,
                :headers => headers
            )
            
            @result = validate_sign_up_code["result"]
            @message = validate_sign_up_code["message"] #Message comes from the API to help with future I18n multilingualism.
            @payload = validate_sign_up_code["payload"]
            
            #ITTT result.
            if @result == "success"
              
                @next_step_message = "Let's continue to set up your profile"
                @uid = @payload["uid"]
            
            else
            
                if @message.present?
                    @error_message = @message
                else
                    @error_message = "Sorry, there was an error validating your sign up code."
                end  
            
            end
          
        else
           
            @error_message = "The server did not receive a sign up code? Are you sure you arrived here through an emailed link?"
            
        end
    
        #Resulting JS file and action post sign-up attempt.
        respond_to do |format|
            format.html { render action: 'profile_setup' } #sent here by html link.
        end
            
    end  
    
    def profile_setup
        
        #error check if sign_up_code was provided
        if params[:first_name].present? && params[:last_name].present? && params[:password].present? && params[:uid]
    	       
            #build the query to send to the API server    
            query = {:first_name => params[:first_name], :last_name => params[:last_name], :password => params[:password], :uid => params[:uid]}
            
            #Grab the variables for this connection from the secrets.yml file.
            headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
            
            #Use HTTParty with the address for the API server direftly (and load balancer in production) to a /v1/sign_up service on the API.
            save_profile_setup = HTTParty.post(
                Rails.configuration.access_point['api_domain'] + '/v1/save_profile_setup.json', 
                :query => query,
                :headers => headers
            )
            
            @result = save_profile_setup["result"]
            @message = save_profile_setup["message"] #Message comes from the API to help with future I18n multilingualism.
            @payload = save_profile_setup["payload"]
            
            #ITTT result.
            if @result == "success"
              
                #Create session variable to log in the user.
                @db_session_token = @payload["db_session_token"]
                #Create the db_session_token. Upon log out, destroy this session variable.
                session[:db_session_token] = @db_session_token
            
            else
            
                if @message.present?
                    @error_message = @message
                else
                    @error_message = "Sorry, there was an error saving your setup data."
                end  
            
            end
          
        else
           
            @error_message = "Looks like you're missing some form details. Please have a look."
            
        end
    
        #Resulting JS file and action setup data save attempt.
        respond_to do |format|
            format.js { render action: 'save_profile_data_results' }
        end
        
    end 
    
    def login
       
       #initial path to login page
        respond_to do |format|
            format.html { render action: 'login' }
        end
        
    end    
    
end

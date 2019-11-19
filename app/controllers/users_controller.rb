class UsersController < ApplicationController
    
    def sign_up
        
        #error check if email was provided.
        if params[:email].present?
    	       
    	   #build the query to send to the API server    
          query = {:email => params[:email]}
    
          #Grab the variables for this connection from the secrets.yml file.
          headers = set_headers
          
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
    
    def profile_setup
        
        #error check if first_name, last_name and password was provided
        if params[:first_name].present? && params[:last_name].present? && params[:password].present? && params[:uid].present?
    	       
            #build the query to send to the API server    
            query = {:first_name => params[:first_name], :last_name => params[:last_name], :password => params[:password], :uid => params[:uid]}
            
            #Grab the variables for this connection from the secrets.yml file.
            headers = set_headers 
            
            #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/save_profile_setup service on the API.
            save_profile_data = HTTParty.post(
                Rails.configuration.access_point['api_domain'] + '/v1/save_profile_setup.json', 
                :query => query,
                :headers => headers
            )
            
            @result = save_profile_data["result"]
            @message = save_profile_data["message"] #Message comes from the API to help with future I18n multilingualism.
            @payload = save_profile_data["payload"]
            
            #ITTT result.
            if @result == "success"
              
                #render blogs html
                
                #Create cookie that expires in 24hrs 
                cookies[:db_session_token] = { value: @payload["db_session_token"], expires: 1.day }
                
            else
            
                if @message.present?
                    @error_message = @message
                else
                    @error_message = "Sorry, there was an error saving your profile setup."
                end  
            
            end
          
        else
           
            @error_message = "Looks like you\'re missing some form data. Please have a look."
            
        end
    
        #Resulting HTML file from setup save attempt.
        respond_to do |format|
            format.js { render action: 'save_profile_data_results' }
        end
        
    end    
    
    def confirm_account
        
        #error check if sign_up_code was provided
        if params[:sign_up_code].present?
    	       
            #build the query to send to the API server    
            query = {:sign_up_code => params[:sign_up_code]}
            
            #Grab the variables for this connection from the secrets.yml file.
            headers = set_headers
            
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
    
        #Resulting HTML file from setup save attempt.
        respond_to do |format|
            format.html { render action: 'profile_setup' }
        end
            
    end
    
    def login
       
       if cookies[:db_session_token].present?
           #redirect to blogs if already logged in.
           redirect_to "/blogs"
       else
            #initial path to login page
            respond_to do |format|
                format.html { render action: 'login' }
            end 
       end       
        
    end    
    
    def logout
        
        #build the query to send to the API server    
        query = {:db_session_token => cookies[:db_session_token]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = set_headers 
        
        #Use HTTParty with the address for the API server direftly (and load balancer in production) to a /v1/nil_db_session_token service on the API.
        nil_db_session_token = HTTParty.get(
            Rails.configuration.access_point['api_domain'] + '/v1/nil_db_session_token.json', 
            :query => query,
            :headers => headers
        )
        
        #delete login cookie locally.
        cookies.delete :db_session_token
        
        #send to login page
        respond_to do |format|
            format.js { render action: 'refresh_to_login' }
        end
        
    end
    
    def process_login
        
        #error check if first_name, last_name and password was provided
        if params[:email].present? && params[:password].present?
    	       
            #build the query to send to the API server    
            query = {:email => params[:email], :password => params[:password]}
            
            #Grab the variables for this connection from the secrets.yml file.
            headers = set_headers 
            
            #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/process_login service on the API.
            process_login_call = HTTParty.post(
                Rails.configuration.access_point['api_domain'] + '/v1/process_login.json', 
                :query => query,
                :headers => headers
            )
            
            @result = process_login_call["result"]
            @message = process_login_call["message"] #Message comes from the API to help with future I18n multilingualism.
            @payload = process_login_call["payload"]

            #ITTT result.
            if @result == "success"
              
                #render blogs html
                
                #Create cookie that expires in 24hrs 
                cookies[:db_session_token] = { value: @payload["db_session_token"], expires: 1.day }
                
            else
            
                if @message.present?
                    @error_message = @message
                else
                    @error_message = "Sorry, there was an error processing your log in information."
                end  
            
            end
          
        else
           
            @error_message = "Looks like you\'re missing some form data. Please have a look."
            
        end
    
        #Resulting HTML file from setup save attempt.
        respond_to do |format|
            format.js { render action: 'login_processing_results' }
        end
        
    end    
    
end


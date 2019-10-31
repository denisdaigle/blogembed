class UsersController < ApplicationController
    
    def profile_setup
        #
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
            
            #ITTT result.
            if @result == "success"
              
                @next_step_message = "Let's continue to set up your profile"
            
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
            format.html { render action: 'sign_up_code_validation_results' } #sent here by html link.
        end
            
    end  
    
    def login
       
       #initial path to login page
        respond_to do |format|
            format.html { render action: 'login' }
        end
        
    end    
    
end

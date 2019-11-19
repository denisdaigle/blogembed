class UpgradeController < ApplicationController
  
  skip_before_action :verify_authenticity_token, :only => [:process_upgrade]
  
  before_action :check_db_session_token
  
  def check_db_session_token
  
    #error check if email was provided.
    if cookies[:db_session_token].present?
	       
	   #build the query to send to the API server    
      query = {:db_session_token => cookies[:db_session_token]}

      #Grab the variables for this connection from the secrets.yml file.
      headers = set_headers 
      
      #Use HTTParty with the address for the API server direftly (and load balancer in production) to a /v1/check_db_session_token service on the API.
      check_db_session_token_call = HTTParty.get(
        Rails.configuration.access_point['api_domain'] + '/v1/check_db_session_token.json', 
        :query => query,
        :headers => headers
      )
      
      @result = check_db_session_token_call["result"]
      @message = check_db_session_token_call["message"] #Message comes from the API to help with future I18n multilingualism.
      @payload = check_db_session_token_call["payload"]

      #ITTT result.
      if @result == "success"
          
          #allow through
          @account_type = @payload["account_type"]

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
  
  def offer
    
    #Let's check to see what type of account this user is using.
    
    #build the query to send to the API server    
    query = {:db_session_token => cookies[:db_session_token]}
      
    #Grab the variables for this connection from the secrets.yml file.
    headers = set_headers
    
    #Use HTTParty with the address for the API server direftly (and load balancer in production) to a /v1/check_account_type service on the API.
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
        
      if @payload["account_type"] == "hero"
        @already_upgraded = true
      else
        @already_upgraded = false
      end
    
    else
    
      @already_upgraded = false
    
    end
    
  end
  
  def process_upgrade
    
    #Stripe passes: params[:stripeToken] as a string like "tok_1FehLpI6NztZfsjNOHJHJASD"

    if params[:stripeToken].present?
      
      #build the query to send to the API server    
      query = {:db_session_token => cookies[:db_session_token], :stripeToken => params[:stripeToken]}
        
      #Grab the variables for this connection from the secrets.yml file.
      headers = set_headers
      
      #Use HTTParty with the address for the API server direftly (and load balancer in production) to a /v1/process_upgrade service on the API.
      process_upgrade_call = HTTParty.post(
        Rails.configuration.access_point['api_domain'] + '/v1/process_upgrade.json', 
        :query => query,
        :headers => headers
      )
      
      @result = process_upgrade_call["result"]
      @message = process_upgrade_call["message"] #Message comes from the API to help with future I18n multilingualism.
  
      #ITTT result.
      if @result == "success"
        
          @success_message = @message
          
      else
      
          @reason = process_upgrade_call["reason"]
  
          if @message.present?
              @error_message = @message
          else
              @error_message = "Sorry, there was an error processing this upgrade."
          end  
      
      end
      
    else
      
      @error_message = "Sorry, you are missing the Stripe Token for this purchase."
      
    end  
    
    if @error_message.present?
      redirect_to "/payment_issue?error_message=#{@error_message}" #Create info popup
    else
      redirect_to "/upgrade"
    end
    
  end
  
  def payment_issue
    #will render payment_issue.html.erb
    @error_message = params[:error_message]
  end  
  
end

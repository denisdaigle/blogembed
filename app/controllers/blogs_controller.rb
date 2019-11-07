class BlogsController < ApplicationController

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

  def blogs
    
    #fetch blogs from database.

    #build the query to send to the API server    
    query = {:db_session_token => cookies[:db_session_token]}
    
    #Grab the variables for this connection from the secrets.yml file.
    headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
    
    #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/save_blog_and_post_content service on the API.
    fetch_blogs_from_database = HTTParty.get(
        Rails.configuration.access_point['api_domain'] + '/v1/fetch_blogs_from_database.json', 
        :query => query,
        :headers => headers
    )
    
    @result = fetch_blogs_from_database["result"]
    @message = fetch_blogs_from_database["message"] #Message comes from the API to help with future I18n multilingualism.
    @payload = fetch_blogs_from_database["payload"]

    #ITTT result.
    if @result == "success"
      
        @blogs = @payload["blogs"]
        
    else
    
        if @message.present?
            @error_message = @message
        else
            @error_message = "Sorry, there was an error fetching your blogs and posts"
        end  
    
    end
    
  end
  
  def create
    #render html needed to create a blog and/or post
    
    if params[:what].present? && params[:what] == "blog_and_post"
      
      respond_to do |format|
          format.js { render action: 'load_create_blog_and_post_editor' }
      end
      
    else
      
    end  
    
  end  
  
  def save_blog_and_post_content
    
    #error check if blog_name, post_title and post_content was provided
    if params[:blog_name].present? && params[:post_title].present? && params[:post_content].present? && cookies[:db_session_token].present?
	       
        #build the query to send to the API server    
        query = {:blog_name => params[:blog_name], :post_title => params[:post_title], :post_content => params[:post_content], :db_session_token => cookies[:db_session_token]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/save_blog_and_post_content service on the API.
        save_blog_and_post_content_call = HTTParty.post(
            Rails.configuration.access_point['api_domain'] + '/v1/save_blog_and_post_content.json', 
            :query => query,
            :headers => headers
        )
        
        @result = save_blog_and_post_content_call["result"]
        @message = save_blog_and_post_content_call["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = save_blog_and_post_content_call["payload"]

        #ITTT result.
        if @result == "success"
          
            @post = @payload["post"]
            
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error saving your blog and post content."
            end  
        
        end
      
    else
       
        @error_message = "Looks like you are missing some form data. Please have a look."
        
    end

    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'save_blog_and_post_content_call_results' }
    end
    
  end  
  
  def view_post
      
    #fetch post from database.

    if params[:uid].present?
       
       #build the query to send to the API server    
        query = {:post_uid => params[:uid], :db_session_token => cookies[:db_session_token]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/fetch_post_from_database service on the API.
        fetch_post_from_database = HTTParty.get(
            Rails.configuration.access_point['api_domain'] + '/v1/fetch_post_from_database.json', 
            :query => query,
            :headers => headers
        )
        
        @result = fetch_post_from_database["result"]
        @message = fetch_post_from_database["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = fetch_post_from_database["payload"]
    
        #ITTT result.
        if @result == "success"
          
            @post = @payload["post"]
            
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error fetching your post."
            end  
        
        end

    else
        
        @result = "failure"
        
        @error_message = "Sorry, without a post uid, we cannot find your post."
        
    end    
    
    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'fetch_post_from_database_results' }
    end
      
  end      
  
  def edit_post
      
    #fetch post from database.

    if params[:uid].present?
       
       #build the query to send to the API server    
        query = {:post_uid => params[:uid], :db_session_token => cookies[:db_session_token]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/fetch_post_from_database service on the API.
        fetch_post_from_database = HTTParty.get(
            Rails.configuration.access_point['api_domain'] + '/v1/fetch_post_from_database.json', 
            :query => query,
            :headers => headers
        )
        
        @result = fetch_post_from_database["result"]
        @message = fetch_post_from_database["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = fetch_post_from_database["payload"]
    
        #ITTT result.
        if @result == "success"
          
            @post = @payload["post"]
            
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error fetching your post."
            end  
        
        end

    else
        
        @result = "failure"
        
        @error_message = "Sorry, without a post uid, we cannot find your post."
        
    end    
    
    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'load_post_editor' }
    end
      
  end      
  
  def save_post_content
      
    #error check if blog_name, post_title and post_content was provided
    if params[:post_title].present? && params[:post_content].present? && params[:post_uid].present? && cookies[:db_session_token].present?
	       
        #build the query to send to the API server    
        query = {:post_title => params[:post_title], :post_content => params[:post_content], :db_session_token => cookies[:db_session_token], :post_uid => params[:post_uid]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/save_blog_and_post_content service on the API.
        save_post_changes = HTTParty.post(
            Rails.configuration.access_point['api_domain'] + '/v1/save_post_changes.json', 
            :query => query,
            :headers => headers
        )
        
        @result = save_post_changes["result"]
        @message = save_post_changes["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = save_post_changes["payload"]

        #ITTT result.
        if @result == "success"
          
            @post = @payload["post"]
            
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error saving your post content."
            end  
        
        end
      
    else
       
        @error_message = "Looks like you are missing some form data. Please have a look."
        
    end

    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'save_post_content_call_results' }
    end
      
  end      
  
end

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
  
  def create_blog_and_post
    
    respond_to do |format|
        format.html { render action: 'blog_and_post_creator' }
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
        format.html { render action: 'post' }
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
        format.html { render action: 'post_editor' }
    end
      
  end
  
  def delete_post
    
    #fetch post from database.

    if params[:uid].present?
       
       #build the query to send to the API server    
        query = {:post_uid => params[:uid], :db_session_token => cookies[:db_session_token]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/delete_post service on the API.
        delete_post_call = HTTParty.get(
            Rails.configuration.access_point['api_domain'] + '/v1/delete_post.json', 
            :query => query,
            :headers => headers
        )
        
        @result = delete_post_call["result"]
        @message = delete_post_call["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = delete_post_call["payload"]
    
        #ITTT result.
        if @result == "success"
          
            @broadcast_message = @message
            
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error deleting this post."
            end  
        
        end

    else
        
        @result = "failure"
        
        @error_message = "Sorry, without a post uid, we cannot find this post to delete."
        
    end    
    
    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'delete_post_results' }
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
  
  def delete_blog

    if params[:uid].present?
       
       #build the query to send to the API server    
        query = {:blog_uid => params[:uid], :db_session_token => cookies[:db_session_token]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/delete_blog service on the API.
        delete_post_call = HTTParty.get(
            Rails.configuration.access_point['api_domain'] + '/v1/delete_blog.json', 
            :query => query,
            :headers => headers
        )
        
        @result = delete_post_call["result"]
        @message = delete_post_call["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = delete_post_call["payload"]
    
        #ITTT result.
        if @result == "success"
          
            @broadcast_message = @message
            
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error deleting this blog."
            end  
        
        end

    else
        
        @result = "failure"
        
        @error_message = "Sorry, without a post uid, we cannot find this blog to delete."
        
    end    
    
    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'delete_blog_results' }
    end
      
  end
  
  def add_a_post_to_blog
      
      if params[:uid].present?
          
        @blog_uid = params[:uid]
        
      else
          
        @error_message = "Sorry, we can't create a post for this blog. The Blog UID is missing."  
      
      end  
      
      respond_to do |format|
        format.html { render action: 'post_creator' }
      end
      
  end    
  
  def create_post
      
    #error check if blog_name, post_title and post_content was provided
    if params[:post_title].present? && params[:post_content].present? && params[:blog_uid].present? && cookies[:db_session_token].present?
	       
        #build the query to send to the API server    
        query = {:post_title => params[:post_title], :post_content => params[:post_content], :db_session_token => cookies[:db_session_token], :blog_uid => params[:blog_uid]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/create_post service on the API.
        create_post_coll = HTTParty.post(
            Rails.configuration.access_point['api_domain'] + '/v1/create_post.json', 
            :query => query,
            :headers => headers
        )
        
        @result = create_post_coll["result"]
        @message = create_post_coll["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = create_post_coll["payload"]

        #ITTT result.
        if @result == "success"
          
            @post = @payload["post"]
            
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error creating this post."
            end  
        
        end
      
    else
       
        @error_message = "Looks like you are missing some form data. Please have a look."
        
    end

    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'create_post_results' }
    end
      
  end
  
  def edit_blog
     
    #fetch blog from database.

    if params[:uid].present?
       
       #build the query to send to the API server    
        query = {:blog_uid => params[:uid], :db_session_token => cookies[:db_session_token]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/fetch_blog_details_from_database service on the API.
        fetch_blog_details_from_database = HTTParty.get(
            Rails.configuration.access_point['api_domain'] + '/v1/fetch_blog_details_from_database.json', 
            :query => query,
            :headers => headers
        )
        
        @result = fetch_blog_details_from_database["result"]
        @message = fetch_blog_details_from_database["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = fetch_blog_details_from_database["payload"]
    
        #ITTT result.
        if @result == "success"
          
            @blog_details = @payload["blog_details"]
            
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error fetching your blog details to edit."
            end  
        
        end

    else
        
        @result = "failure"
        
        @error_message = "Sorry, without a blog uid, we cannot find your blog."
        
    end    
    
    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'load_inline_blog_editor' }
    end
      
  end     
  
  def save_blog_details_changes

    if params[:blog_uid].present? && params[:blog_name].present?
       
       #build the query to send to the API server    
        query = {:blog_name => params[:blog_name], :blog_uid => params[:blog_uid], :db_session_token => cookies[:db_session_token]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/save_blog_details_changes service on the API.
        save_blog_details_changes_call = HTTParty.post(
            Rails.configuration.access_point['api_domain'] + '/v1/save_blog_details_changes.json', 
            :query => query,
            :headers => headers
        )
        
        @result = save_blog_details_changes_call["result"]
        @message = save_blog_details_changes_call["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = save_blog_details_changes_call["payload"]
    
        #ITTT result.
        if @result == "success"
          
            @blog_details = @payload["blog_details"]
            
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error fetching your blog details to edit."
            end  
        
        end

    else
        
        @result = "failure"
        
        @error_message = "Sorry, without a blog uid, we cannot find your blog."
        
    end    
    
    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'save_blog_details_changes_results' }
    end
      
  end      
  
end

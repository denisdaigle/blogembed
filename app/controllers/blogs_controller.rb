class BlogsController < ApplicationController

  before_action :check_db_session_token, :except => :embed
  
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
  
    
  def embed
    
    if params[:uid].present?
        
        #Let's make sure this is not a diret link access.
        if request.referrer.present?
        
            #Let's capture the requesting url.
            @requesting_url = request.referrer.gsub("https://", "").gsub("http://", "").gsub("/", "")
            
            #build the query to send to the API server    
            query = {:post_uid => params[:uid], :requesting_url => @requesting_url}
            
            #Grab the variables for this connection from the secrets.yml file.
            headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
            
            #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/fetch_post_from_database service on the API.
            fetch_post_for_embed = HTTParty.get(
                Rails.configuration.access_point['api_domain'] + '/v1/fetch_post_for_embed.json', 
                :query => query,
                :headers => headers
            )
            
            @result = fetch_post_for_embed["result"]
            @message = fetch_post_for_embed["message"] #Message comes from the API to help with future I18n multilingualism.
            @payload = fetch_post_for_embed["payload"]
    
            #ITTT result.
            if @result == "success"
              
                @post = @payload["post"]
                
            else
            
                @reason = fetch_post_for_embed["reason"]
    
                if @message.present?
                    @error_message = @message
                else
                    @error_message = "Sorry, there was an error fetching this post."
                end  
            
            end
        
        else
            
            @reason = "no_referrer"
            @error_message = "Hi there, this protected content can only be viewed using an <iframe> tag."
            
        end

    else
        
        @result = "failure"
        
        @error_message = "Sorry, without a post uid, we cannot find your post."
        
    end
    
    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.html { render action: 'embed_post', layout: 'embed' }
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
  
  def publish_post
    
    if params[:uid].present?
       
       #build the query to send to the API server    
        query = {:post_uid => params[:uid], :db_session_token => cookies[:db_session_token]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/publish_post service on the API.
        publish_post_call = HTTParty.get(
            Rails.configuration.access_point['api_domain'] + '/v1/publish_post.json', 
            :query => query,
            :headers => headers
        )
        
        @result = publish_post_call["result"]
        @message = publish_post_call["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = publish_post_call["payload"]
    
        #ITTT result.
        if @result == "success"
          
            @post = @payload["post"]
            
        else
        
            @reason = publish_post_call["reason"]
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error publishing this post."
            end  
        
        end

    else
        
        @result = "failure"
        
        @error_message = "Sorry, without a post uid, we cannot find this post to publish."
        
    end    
    
    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'publish_results' }
    end
      
  end  
  
  def unpublish_post
    
    if params[:uid].present?
       
       #build the query to send to the API server    
        query = {:post_uid => params[:uid], :db_session_token => cookies[:db_session_token]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/unpublish_post service on the API.
        unpublish_post_call = HTTParty.get(
            Rails.configuration.access_point['api_domain'] + '/v1/unpublish_post.json', 
            :query => query,
            :headers => headers
        )
        
        @result = unpublish_post_call["result"]
        @message = unpublish_post_call["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = unpublish_post_call["payload"]
    
        #ITTT result.
        if @result == "success"
          
            @post = @payload["post"]
            
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error unpublishing this post."
            end  
        
        end

    else
        
        @result = "failure"
        
        @error_message = "Sorry, without a post uid, we cannot find this post to unpublish."
        
    end    
    
    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'unpublish_results' }
    end
      
  end
 
  def get_add_permitted_domain_form
  
    #fetch blog from database.

    if params[:uid].present?
        
       @blog_uid = params[:uid]

    else
        
        @result = "failure"
        
        @error_message = "Sorry, without a blog uid, we cannot find your blog to change permitted domains."
        
    end    
    
    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'load_inline_permitted_domain_adder' }
    end
  
  end     
  
  def add_permitted_domain
      
    if params[:blog_uid].present? && params[:permitted_domain].present?
       
       #build the query to send to the API server    
        query = {:permitted_domain => params[:permitted_domain], :blog_uid => params[:blog_uid], :db_session_token => cookies[:db_session_token]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/add_permitted_domain service on the API.
        add_permitted_domain_call = HTTParty.post(
            Rails.configuration.access_point['api_domain'] + '/v1/add_permitted_domain.json', 
            :query => query,
            :headers => headers
        )
        
        @result = add_permitted_domain_call["result"]
        @message = add_permitted_domain_call["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = add_permitted_domain_call["payload"]
    
        #ITTT result.
        if @result == "success"
            
            @blog_details = @payload["blog_details"]
            
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error adding this permitted domain."
            end  
        
        end

    else
        
        @result = "failure"
        
        @error_message = "Sorry, your blog uid or permitted domain is missing."
        
    end    
    
    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'add_permitted_domain_results' }
    end
      
  end      
  
  def remove_permitted_domain
      
    if params[:uid].present?
       
       #build the query to send to the API server    
        query = {:permitted_domain_uid => params[:uid], :db_session_token => cookies[:db_session_token]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/add_permitted_domain service on the API.
        remove_permitted_domain_call = HTTParty.get(
            Rails.configuration.access_point['api_domain'] + '/v1/remove_permitted_domain.json', 
            :query => query,
            :headers => headers
        )
        
        @result = remove_permitted_domain_call["result"]
        @message = remove_permitted_domain_call["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = remove_permitted_domain_call["payload"]
    
        #ITTT result.
        if @result == "success"
            
            @blog_details = @payload["blog_details"]
            
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error removing this permitted domain."
            end  
        
        end

    else
        
        @result = "failure"
        
        @error_message = "Sorry, your permitted domain uid is missing."
        
    end    
    
    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'remove_permitted_domain_results' }
    end
      
  end      
  
  def reload_blog_details
      
    if params[:uid].present?
       
       #build the query to send to the API server    
        query = {:blog_uid => params[:uid], :db_session_token => cookies[:db_session_token]}
        
        #Grab the variables for this connection from the secrets.yml file.
        headers = { 'X-Api-Access-Key' => Rails.application.secrets.api_access_key, 'X-Api-Access-Secret' => Rails.application.secrets.api_access_secret } 
        
        #Use HTTParty with the address for the API server directly (and load balancer in production) to a /v1/fetch_blog_details service on the API.
        fetch_blog_details = HTTParty.get(
            Rails.configuration.access_point['api_domain'] + '/v1/fetch_blog_details.json', 
            :query => query,
            :headers => headers
        )
        
        @result = fetch_blog_details["result"]
        @message = fetch_blog_details["message"] #Message comes from the API to help with future I18n multilingualism.
        @payload = fetch_blog_details["payload"]

        #ITTT result.
        if @result == "success"
          Rails.logger.debug "@payload #{@payload}"
            @blog_details = @payload["blog_details"]
            Rails.logger.debug "@blog_details #{@blog_details}"
        else
        
            if @message.present?
                @error_message = @message
            else
                @error_message = "Sorry, there was an error fetching blog details."
            end  
        
        end

    else
        
        @result = "failure"
        
        @error_message = "Sorry, without a blog uid, we cannot find your blog."
        
    end    
    
    #Resulting HTML file from setup save attempt.
    respond_to do |format|
        format.js { render action: 'reload_blog_details_results' }
    end
      
  end      
  
end

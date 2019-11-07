class BlogsController < ApplicationController

  def list
    #fetch blogs from database.
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
  
end

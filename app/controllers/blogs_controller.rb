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
    #tbd
  end  
  
end

class Post
    
  include ActiveModel::Model

  #attr_accessor :content

  has_rich_text :content
  
end
Rails.application.routes.draw do
  
  get 'blogs/list'
  get 'passwords/request_reset_password_link'
  get '/welcome' => "pages#welcome"
  
  #USERS
  post '/user_sign_up' => "users#sign_up"
  get '/confirm_account' => "users#confirm_account"
  post '/user_profile_setup' => "users#profile_setup"
  
  #user sessions
  get '/login' => "users#login"
  get '/logout' => "users#logout"
  post '/process_login' => "users#process_login"
  
  #password
  get '/forgot_password' => "passwords#request_reset_password_link"
  post '/process_password_reset_link_request' => 'passwords#process_password_reset_link_request'
  get '/reset_password' => "passwords#create_new_password"
  post '/process_new_password' => "passwords#process_new_password"
  
  #blogs
  get '/blogs' => "blogs#blogs"
  get '/create' => "blogs#create"
  post '/save_blog_and_post_content' => "blogs#save_blog_and_post_content"
  get '/post' => "blogs#view_post"
  get '/edit_post' => "blogs#edit_post"
  get '/delete_post' => "blogs#delete_post"
  post '/save_post_content' => "blogs#save_post_content"
  get '/edit_blog' => "blogs#edit_blog"
  get '/delete_blog' => "blogs#delete_blog"
  get '/add_a_post_to_blog' => "blogs#add_a_post_to_blog"
  
  get '/ask' => "application#ask"
  get '/inform' => "application#inform"

  root "pages#home"
  
end

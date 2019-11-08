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
  post '/save_post_content' => "blogs#save_post_content"
  
  get '/ask' => "application#ask"

  root "pages#home"
  
end

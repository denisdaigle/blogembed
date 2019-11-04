Rails.application.routes.draw do
  
  get 'passwords/request_reset_password_link'
  get '/welcome' => "pages#welcome"
  
  #dashboard
  get '/dashboard' => "dashboards#dashboard"
  
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
  
  root "pages#home"
  
end

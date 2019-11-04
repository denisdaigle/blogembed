Rails.application.routes.draw do
  
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

  root "pages#home"
  
end

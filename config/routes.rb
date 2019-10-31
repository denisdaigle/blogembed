Rails.application.routes.draw do
  
  post 'connections/connect'
  get '/welcome' => "pages#welcome"
  
  #USERS
  get '/confirm_account' => "users#confirm_account"
  post '/user_profile_setup' => "users#profile_setup"
  get '/login' => "users#login"
  
  root "pages#home" 
end

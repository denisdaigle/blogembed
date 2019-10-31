Rails.application.routes.draw do
  
  
  get 'dashboards/view'
  get '/welcome' => "pages#welcome"
  
  #USERS
  post '/user_sign_up' => "users#sign_up"
  get '/confirm_account' => "users#confirm_account"
  post '/user_profile_setup' => "users#profile_setup"
  get '/login' => "users#login"
  
  get '/dashboard' => "dashboards#view"
  
  root "pages#home"
  
end

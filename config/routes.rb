Rails.application.routes.draw do
  
  post 'connections/connect'
  get '/welcome' => "pages#welcome"
  get '/confirm_account' => "users#confirm_account"
  get '/login' => "users#login"
  
  root "pages#home" 
end

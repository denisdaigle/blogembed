Rails.application.routes.draw do
  post 'connections/connect'
  get 'pages/home'
  get 'pages/try'
  get 'pages/login'
  
  get '/welcome' => "pages#welcome"
  
  root "pages#home" 
end

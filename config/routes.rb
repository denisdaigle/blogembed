Rails.application.routes.draw do
  post 'connections/connect'
  get 'pages/home'
  get 'pages/try'
  get 'pages/login'
  root "pages#home" 
end

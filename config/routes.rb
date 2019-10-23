Rails.application.routes.draw do
  get 'pages/home'
  get 'pages/try'
  get 'pages/login'
  root "pages#home" 
end

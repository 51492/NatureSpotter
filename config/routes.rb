Rails.application.routes.draw do
  
  get 'homes/top'
  get 'homes/about'
  devise_for :admins
  devise_for :users
  
  get '/NatureSpotter' => 'homes#top', as: "top"
  get '/about' => 'homes#about', as: "about"
  
end

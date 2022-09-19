Rails.application.routes.draw do
  get '/product/index', to:"product#index"
  post '/product/create', to:"product#create"
  get '/product/delete/:id', to:"product#delete"
  get '/product/detail/:id', to:"product#detail"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "product#add"
end

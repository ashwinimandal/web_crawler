Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#index"

  get 'get_root_domain', as: '/get_root_domain', to: 'home#get_root_domain'
end

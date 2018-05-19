Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'urls#index'
  get "/:short_url", to: "urls#show"
  get "shorty/:short_url", to: "urls#shorty", as: :shorty
  get 'urls/top'
  resources :urls, only: :create
end

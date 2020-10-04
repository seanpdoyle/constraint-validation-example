Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :messages, only: [:index, :create]
  resources :authentications, only: [:new, :create]
  resource :authentication, only: :destroy

  root to: redirect("/messages")
end

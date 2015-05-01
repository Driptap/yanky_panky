Rails.application.routes.draw do
  root 'application#index'
  resources :users do
    get 'dash'
    get 'new_track'
    get 'skip_track'
  	post 'store_track_info'
  end
  get "login_or_signup", to: "users#login_or_signup"
  get "dropbox_callback", to: "users#dropbox_callback"
end

Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  
  resources :users do
   # get 'get_started'
    get 'dash'
   # get 'dropbox_callback'
    get 'new_track'
    get 'skip_track'
  end
    
  post "login_or_signup", to: "users#login_or_signup"
  get "dropbox_callback", to: "users#dropbox_callback"

end

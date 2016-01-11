Rails.application.routes.draw do
  # Easier to make GET request from the client
  devise_for :users, sign_out_via: [:get, :delete],
             controllers: {sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords', confirmations: 'users/confirmations', omniauth_callbacks: 'callbacks'}

  root 'home#index'

  # Provider stuff
  match '/auth/login/authorize' => 'auth#authorize', via: :all
  match '/auth/login/access_token' => 'auth#access_token', via: :all
  match '/auth/login/user' => 'auth#user', via: :all
  match '/oauth/token' => 'auth#access_token', via: :all


  match '/auth/register/authorize' => 'auth_register#authorize', via: :all
  match '/auth/register/access_token' => 'auth_register#access_token', via: :all
  match '/auth/register/user' => 'auth_register#user', via: :all
  # match '/oauth/token' => 'auth#access_token', via: :all

  resources :accounts, only: [:new, :create, :destroy] do
    collection do
      post :register_email_exists
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

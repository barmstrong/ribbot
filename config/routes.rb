Ribbot::Application.routes.draw do

  resources :posts do
    resources :comments
  end
  resources :forums
  resources :votes
  resources :users do
    member do
      put :password_reset
    end
    collection do
      post :create_with_forum
    end
  end
  resources :participations do
    member do
      put :ban
      put :unban
      put :hide
    end
  end
  resources :themes
  resources :pages
  
  namespace :account do
    resources :comments
    resources :posts
    resource  :profile
    resources :users
    resources :settings
    resources :tags do
      post :sort, :on => :collection
    end
    resources :pages do
      post :sort, :on => :collection
    end
    resources :themes do
      post :install, :on => :member
      post :uninstall, :on => :collection
    end
    resource :ownership
    resource :domain
  end
  
  namespace :superuser do
    resources :forums
  end
  
  resources :verifications
  resources :password_resets
  resources :sessions

  match 'signin' => "sessions#new"
  match 'signout' => "sessions#destroy", :via => :delete
  match 'features' => 'static#features'
  match 'pricing' => 'static#pricing'
  
  constraints(Subdomain) do
    match '/' => 'posts#index'  
  end
  
  root :to => 'users#new'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'users#new'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

Rails.application.routes.draw do

  get 'welcome/index'
  get "/contact" => "welcome#contact"


  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}


  root to: 'welcome#index'

  namespace :api, defaults: {format: :json} do
    scope '/request' do
      get '/user/:id'  => 'requests#ldap_user'
      get '/group/:id' => 'requests#ldap_group'
      get '/user/'     => 'requests#ldap_user'
      get '/group/'    => 'requests#ldap_group'
    end


    resources :ldap_users, only: [:index, :show, :create, :update, :destroy]
    resources :ldap_groups, only: [:index, :show, :create, :update, :destroy]
  end

  get "*path.html" => "application#index", :layout => 0
  get "*path" => "application#index"


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

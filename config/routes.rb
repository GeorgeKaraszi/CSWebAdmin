Rails.application.routes.draw do

  get 'welcome/index'
  get "/contact" => "welcome#contact"


  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}


  authenticated :user do
    root to: 'welcome#index', as: :authenticated_root

    resources :ldap_users do
      member do
        get '/db/export' => 'ldap_users#export_db', :format => 'json'
        get '/ldap/export' => 'ldap_users#export_ldap', :format => 'json'
      end
      collection do
        get '/db/export' => 'ldap_users#export_db', :format => 'json'
        get '/ldap/export' => 'ldap_users#export_ldap', :format => 'json'
      end
    end

    resources :ldap_groups
    #match '/request/:type:name:excludes' => 'request#export', via: :get

  end
  root :to => redirect('login')


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

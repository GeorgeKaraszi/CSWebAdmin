Rails.application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get 'welcome/index'
  get "/contact" => "welcome#contact"


  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}


  root to: 'welcome#index'

  namespace :api, defaults: {format: :json} do
    scope '/v1' do
      scope '/user' do
        get '/'     => 'requests#ldap_user'
        get '/:id'  => 'requests#ldap_user'
        get '/new'  => 'requests#ldap_user'
      end

      scope '/group' do
        get '/'     => 'requests#ldap_group'
        get '/:id'  => 'requests#ldap_group'
        get '/new'  => 'requests#ldap_group'
      end

      scope '/request' do
        get '/'                   => 'requests#index'
        get '/schema'             => 'requests#ldap_schema_list'
        get '/schema/:schema'     => 'requests#ldap_schema_attributes'
        get '/:id/schema'         => 'requests#ldap_schema_list'
        get '/:id/schema/:schema' => 'requests#ldap_schema_attributes'
        get '/:id'                => 'requests#ldap_attributes'

      end
    end


    resources :ldap_users, only: [:index, :show, :create, :update, :destroy]
    resources :ldap_groups, only: [:index, :show, :create, :update, :destroy]

  end

  get "*path.html" => "application#index", :layout => 0
  get "*path" => "application#index"
end

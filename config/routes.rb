DaBvRails::Application.routes.draw do

  resources :roster_assignments

  # Users
  devise_for :users

  # User Profiles
  resources :user_profiles, :only => [:show, :edit, :update]

  # Communities
  resources :communities, :except => :destroy

  # Games
  match "/game/:id" => "games#show", :as => "game"
  resources :games, :only => :show

  match "/wow_characters/new" => "base_characters#new", :as => "new_wow_character"
  match "/swtor_characters/new" => "base_characters#new", :as => "new_swtor_character"
  resources :wow_characters, :except => [:index, :new]
  resources :swtor_characters, :except => [:index, :new]
  resources :base_characters, :only => :new

  # Subdomains
  constraints(Subdomain) do
    match "/" => "subdomains#index", :as => 'subdomain_home'
    resources :roles do
      resources :permissions
    end
  end

  # Home
  root :to => 'home#index'
  get "home/index"

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
#== Route Map
# Generated on 10 Sep 2011 20:35
#
#             user_session POST   /users/sign_in(.:format)             {:action=>"create", :controller=>"devise/sessions"}
#     destroy_user_session DELETE /users/sign_out(.:format)            {:action=>"destroy", :controller=>"devise/sessions"}
#            user_password POST   /users/password(.:format)            {:action=>"create", :controller=>"devise/passwords"}
#        new_user_password GET    /users/password/new(.:format)        {:action=>"new", :controller=>"devise/passwords"}
#       edit_user_password GET    /users/password/edit(.:format)       {:action=>"edit", :controller=>"devise/passwords"}
#                          PUT    /users/password(.:format)            {:action=>"update", :controller=>"devise/passwords"}
# cancel_user_registration GET    /users/cancel(.:format)              {:action=>"cancel", :controller=>"devise/registrations"}
#        user_registration POST   /users(.:format)                     {:action=>"create", :controller=>"devise/registrations"}
#    new_user_registration GET    /users/sign_up(.:format)             {:action=>"new", :controller=>"devise/registrations"}
#   edit_user_registration GET    /users/edit(.:format)                {:action=>"edit", :controller=>"devise/registrations"}
#                          PUT    /users(.:format)                     {:action=>"update", :controller=>"devise/registrations"}
#                          DELETE /users(.:format)                     {:action=>"destroy", :controller=>"devise/registrations"}
#        user_confirmation POST   /users/confirmation(.:format)        {:action=>"create", :controller=>"devise/confirmations"}
#    new_user_confirmation GET    /users/confirmation/new(.:format)    {:action=>"new", :controller=>"devise/confirmations"}
#                          GET    /users/confirmation(.:format)        {:action=>"show", :controller=>"devise/confirmations"}
#              user_unlock POST   /users/unlock(.:format)              {:action=>"create", :controller=>"devise/unlocks"}
#          new_user_unlock GET    /users/unlock/new(.:format)          {:action=>"new", :controller=>"devise/unlocks"}
#                          GET    /users/unlock(.:format)              {:action=>"show", :controller=>"devise/unlocks"}
#              communities GET    /communities(.:format)               {:action=>"index", :controller=>"communities"}
#                          POST   /communities(.:format)               {:action=>"create", :controller=>"communities"}
#            new_community GET    /communities/new(.:format)           {:action=>"new", :controller=>"communities"}
#           edit_community GET    /communities/:id/edit(.:format)      {:action=>"edit", :controller=>"communities"}
#                community GET    /communities/:id(.:format)           {:action=>"show", :controller=>"communities"}
#                          PUT    /communities/:id(.:format)           {:action=>"update", :controller=>"communities"}
#                     game        /game/:id(.:format)                  {:controller=>"games", :action=>"show"}
#                          GET    /games/:id(.:format)                 {:action=>"show", :controller=>"games"}
#           wow_characters POST   /wow_characters(.:format)            {:action=>"create", :controller=>"wow_characters"}
#        new_wow_character GET    /wow_characters/new(.:format)        {:action=>"new", :controller=>"wow_characters"}
#       edit_wow_character GET    /wow_characters/:id/edit(.:format)   {:action=>"edit", :controller=>"wow_characters"}
#            wow_character GET    /wow_characters/:id(.:format)        {:action=>"show", :controller=>"wow_characters"}
#                          PUT    /wow_characters/:id(.:format)        {:action=>"update", :controller=>"wow_characters"}
#                          DELETE /wow_characters/:id(.:format)        {:action=>"destroy", :controller=>"wow_characters"}
#         swtor_characters POST   /swtor_characters(.:format)          {:action=>"create", :controller=>"swtor_characters"}
#      new_swtor_character GET    /swtor_characters/new(.:format)      {:action=>"new", :controller=>"swtor_characters"}
#     edit_swtor_character GET    /swtor_characters/:id/edit(.:format) {:action=>"edit", :controller=>"swtor_characters"}
#          swtor_character GET    /swtor_characters/:id(.:format)      {:action=>"show", :controller=>"swtor_characters"}
#                          PUT    /swtor_characters/:id(.:format)      {:action=>"update", :controller=>"swtor_characters"}
#                          DELETE /swtor_characters/:id(.:format)      {:action=>"destroy", :controller=>"swtor_characters"}
#       new_base_character GET    /base_characters/new(.:format)       {:action=>"new", :controller=>"base_characters"}
#           subdomain_home        /                                    {:controller=>"subdomains", :action=>"index"}
#                     root        /                                    {:controller=>"home", :action=>"index"}
#               home_index GET    /home/index(.:format)                {:controller=>"home", :action=>"index"}

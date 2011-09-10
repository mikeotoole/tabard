DaBvRails::Application.routes.draw do

  # Users
  devise_for :users
	
  # User Profiles
  resources :user_profiles, :only => [:show, :edit, :update]

  # Communities
  resources :communities, :except => :destroy

  # Games
  match "/game/:id" => "games#show", :as => "game"
  resources :games, :only => :show do
    resources :wow_characters, :except => :index
    resources :swtor_characters, :except => :index
  end
  resources :wow_characters, :only => :show
  resources :swtor_characters, :only => :show
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
# Generated on 06 Sep 2011 13:27
#
#                          POST   /communities(.:format)                         {:action=>"create", :controller=>"communities"}
#            new_community GET    /communities/new(.:format)                     {:action=>"new", :controller=>"communities"}
#           edit_community GET    /communities/:id/edit(.:format)                {:action=>"edit", :controller=>"communities"}
#                community GET    /communities/:id(.:format)                     {:action=>"show", :controller=>"communities"}
#                          PUT    /communities/:id(.:format)                     {:action=>"update", :controller=>"communities"}
#                          DELETE /communities/:id(.:format)                     {:action=>"destroy", :controller=>"communities"}
#        edit_user_profile GET    /user_profiles/:id/edit(.:format)              {:action=>"edit", :controller=>"user_profiles"}
#             user_profile GET    /user_profiles/:id(.:format)                   {:action=>"show", :controller=>"user_profiles"}
#                          PUT    /user_profiles/:id(.:format)                   {:action=>"update", :controller=>"user_profiles"}
#         new_user_session GET    /users/sign_in(.:format)                       {:action=>"new", :controller=>"devise/sessions"}
#             user_session POST   /users/sign_in(.:format)                       {:action=>"create", :controller=>"devise/sessions"}
#     destroy_user_session DELETE /users/sign_out(.:format)                      {:action=>"destroy", :controller=>"devise/sessions"}
#            user_password POST   /users/password(.:format)                      {:action=>"create", :controller=>"devise/passwords"}
#        new_user_password GET    /users/password/new(.:format)                  {:action=>"new", :controller=>"devise/passwords"}
#       edit_user_password GET    /users/password/edit(.:format)                 {:action=>"edit", :controller=>"devise/passwords"}
#                          PUT    /users/password(.:format)                      {:action=>"update", :controller=>"devise/passwords"}
# cancel_user_registration GET    /users/cancel(.:format)                        {:action=>"cancel", :controller=>"devise/registrations"}
#        user_registration POST   /users(.:format)                               {:action=>"create", :controller=>"devise/registrations"}
#    new_user_registration GET    /users/sign_up(.:format)                       {:action=>"new", :controller=>"devise/registrations"}
#   edit_user_registration GET    /users/edit(.:format)                          {:action=>"edit", :controller=>"devise/registrations"}
#                          PUT    /users(.:format)                               {:action=>"update", :controller=>"devise/registrations"}
#                          DELETE /users(.:format)                               {:action=>"destroy", :controller=>"devise/registrations"}
#        user_confirmation POST   /users/confirmation(.:format)                  {:action=>"create", :controller=>"devise/confirmations"}
#    new_user_confirmation GET    /users/confirmation/new(.:format)              {:action=>"new", :controller=>"devise/confirmations"}
#                          GET    /users/confirmation(.:format)                  {:action=>"show", :controller=>"devise/confirmations"}
#              user_unlock POST   /users/unlock(.:format)                        {:action=>"create", :controller=>"devise/unlocks"}
#          new_user_unlock GET    /users/unlock/new(.:format)                    {:action=>"new", :controller=>"devise/unlocks"}
#                          GET    /users/unlock(.:format)                        {:action=>"show", :controller=>"devise/unlocks"}
#           subdomain_home        /                                              {:controller=>"subdomains", :action=>"index"}
#         role_permissions GET    /roles/:role_id/permissions(.:format)          {:action=>"index", :controller=>"permissions"}
#                          POST   /roles/:role_id/permissions(.:format)          {:action=>"create", :controller=>"permissions"}
#      new_role_permission GET    /roles/:role_id/permissions/new(.:format)      {:action=>"new", :controller=>"permissions"}
#     edit_role_permission GET    /roles/:role_id/permissions/:id/edit(.:format) {:action=>"edit", :controller=>"permissions"}
#          role_permission GET    /roles/:role_id/permissions/:id(.:format)      {:action=>"show", :controller=>"permissions"}
#                          PUT    /roles/:role_id/permissions/:id(.:format)      {:action=>"update", :controller=>"permissions"}
#                          DELETE /roles/:role_id/permissions/:id(.:format)      {:action=>"destroy", :controller=>"permissions"}
#                    roles GET    /roles(.:format)                               {:action=>"index", :controller=>"roles"}
#                          POST   /roles(.:format)                               {:action=>"create", :controller=>"roles"}
#                 new_role GET    /roles/new(.:format)                           {:action=>"new", :controller=>"roles"}
#                edit_role GET    /roles/:id/edit(.:format)                      {:action=>"edit", :controller=>"roles"}
#                     role GET    /roles/:id(.:format)                           {:action=>"show", :controller=>"roles"}
#                          PUT    /roles/:id(.:format)                           {:action=>"update", :controller=>"roles"}
#                          DELETE /roles/:id(.:format)                           {:action=>"destroy", :controller=>"roles"}
#                     root        /                                              {:controller=>"home", :action=>"index"}

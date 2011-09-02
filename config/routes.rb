DaBvRails::Application.routes.draw do

  resources :communities, :except => :destroy

  devise_for :users

  constraints(Subdomain) do
    match "/" => "subdomains#index", :as => "subdomain_home"
  end

  root :to => 'home#index'

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
# Generated on 02 Sep 2011 14:23
#
#                          POST   /communities(.:format)            {:action=>"create", :controller=>"communities"}
#            new_community GET    /communities/new(.:format)        {:action=>"new", :controller=>"communities"}
#           edit_community GET    /communities/:id/edit(.:format)   {:action=>"edit", :controller=>"communities"}
#                community GET    /communities/:id(.:format)        {:action=>"show", :controller=>"communities"}
#                          PUT    /communities/:id(.:format)        {:action=>"update", :controller=>"communities"}
#         new_user_session GET    /users/sign_in(.:format)          {:action=>"new", :controller=>"devise/sessions"}
#             user_session POST   /users/sign_in(.:format)          {:action=>"create", :controller=>"devise/sessions"}
#     destroy_user_session DELETE /users/sign_out(.:format)         {:action=>"destroy", :controller=>"devise/sessions"}
#            user_password POST   /users/password(.:format)         {:action=>"create", :controller=>"devise/passwords"}
#        new_user_password GET    /users/password/new(.:format)     {:action=>"new", :controller=>"devise/passwords"}
#       edit_user_password GET    /users/password/edit(.:format)    {:action=>"edit", :controller=>"devise/passwords"}
#                          PUT    /users/password(.:format)         {:action=>"update", :controller=>"devise/passwords"}
# cancel_user_registration GET    /users/cancel(.:format)           {:action=>"cancel", :controller=>"devise/registrations"}
#        user_registration POST   /users(.:format)                  {:action=>"create", :controller=>"devise/registrations"}
#    new_user_registration GET    /users/sign_up(.:format)          {:action=>"new", :controller=>"devise/registrations"}
#   edit_user_registration GET    /users/edit(.:format)             {:action=>"edit", :controller=>"devise/registrations"}
#                          PUT    /users(.:format)                  {:action=>"update", :controller=>"devise/registrations"}
#                          DELETE /users(.:format)                  {:action=>"destroy", :controller=>"devise/registrations"}
#        user_confirmation POST   /users/confirmation(.:format)     {:action=>"create", :controller=>"devise/confirmations"}
#    new_user_confirmation GET    /users/confirmation/new(.:format) {:action=>"new", :controller=>"devise/confirmations"}
#                          GET    /users/confirmation(.:format)     {:action=>"show", :controller=>"devise/confirmations"}
#              user_unlock POST   /users/unlock(.:format)           {:action=>"create", :controller=>"devise/unlocks"}
#          new_user_unlock GET    /users/unlock/new(.:format)       {:action=>"new", :controller=>"devise/unlocks"}
#                          GET    /users/unlock(.:format)           {:action=>"show", :controller=>"devise/unlocks"}
#                                 /(.:format)                       {:controller=>"subdomains", :action=>"index"}
#                     root        /(.:format)                       {:controller=>"home", :action=>"index"}

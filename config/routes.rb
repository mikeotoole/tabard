Bv::Application.routes.draw do

  resources :recurring_events

  resources :game_locations

  resources :locations

  resources :events

  resources :team_speaks

  resources :page_spaces

  resources :pages

  resources :letters

  resources :donations

  resources :newsletters

  resources :discussion_spaces

  resources :system_resources

  resources :announcements do
    resources :acknowledgment_of_announcements
  end
  
  resources :site_announcements
  resources :game_announcements

  root :to => "home#index"
  
  match '/profiles/newgame' => "profiles#newgame"
  
  match '/login' => "sessions#new", :as => "login"
  match '/logout' => "sessions#destroy", :as => "logout"
  
  match '/management' => "management#index"
  
  resources :profiles do
    resources :acknowledgment_of_announcements
  end
  
  resources :game_profiles do
    resources :acknowledgment_of_announcements
  end
  
  resources :user_profiles do
    resources :acknowledgment_of_announcements
  end
  
  resources :permissions
  resources :roles    
  
  resources :users
  resource :session
  
  resource :active_profile
  match '/activate_profile' => "active_profiles#new", :as => "activate_profile"
  match '/deactivate_profile' => "active_profiles#destroy", :as => "deactivate_profile"
  
  resources :games do
    resources :characters
  end
  
  resources :characters

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

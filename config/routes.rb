Bv::Application.routes.draw do
 
  get "status_code/404"

  resources :sent, :only => [:show, :new, :create]
  match '/sent_messages' => "sent#index"
  
  resources :messages, :only => [:show, :destroy] do
    member do
      post :reply
      post :forward
      post :reply_all
      post :undelete
    end
  end
      
  resource :mailbox, :only => :show
  match '/inbox' => "mailbox#index"
  match '/trash' => "mailbox#trash"

  resources :registration_answers,
    :text_box_questions,
    :radio_button_questions,
    :text_questions,
    :check_box_questions,
    :combo_box_questions,
    :answers,
    :questions

  resources :registration_applications do
    member do
      post :accept
      post :reject
    end
  end

  resources :teamspeaks,
    :recurring_events,
    :game_locations,
    :locations,
    :events,
    :team_speaks

  resources :page_spaces do
    resources :pages
  end  

  resources :letters,
    :donations,
    :newsletters

  resources :discussion_spaces
  
  resources :discussions do
    member do
      post :lock
      post :unlock
    end
  end

  resources :comments do
    member do
      post :lock
      post :unlock
    end
  end
  
  resources :system_resources

  resources :announcements do
    resources :acknowledgment_of_announcements
  end
  
  resources :acknowledgment_of_announcements,
    :site_announcements,
    :game_announcements
  
  match 'announcement/acknowledge' => 'announcement_acknowledgement#new', :as => 'announcement_acknowledgement'

  root :to => "home#index"
  
  match '/profiles/newgame' => "profiles#newgame"
  
  match '/login' => "sessions#new", :as => "login"
  match '/logout' => "sessions#destroy", :as => "logout"
  
  match 'management' => "management/management#index"
  
  namespace "management" do
    resources :users, :except => :show do
      member do
        get :activate
        get :deactivate
      end
    end
    resources :roles do
      resources :permissions
    end
    resources :newsletters,
      :page_spaces,
      :discussion_spaces,
      :themes,
      :teamspeaks,
      :site_forms
  end
  
  resources :site_forms do
    resources :submissions, :only => [:index, :show, :new, :create]
  end
  
  resources :profiles do
    resources :acknowledgment_of_announcements
  end
  
  resources :game_profiles do
    resources :acknowledgment_of_announcements
  end
  
  resources :user_profiles do
    resources :acknowledgment_of_announcements
  end
  
  resources :users, :only => [:index, :show, :edit]
  resource :session
  
  match 'active_profile/:id/:type' => 'active_profiles#create', :as => :active_profile
  
  resources :games do
    resources :wow_characters, :except => :index
    resources :swtor_characters, :except => :index
    resources :game_announcements, :only => [:new, :create]
  end
  resources :wow_characters, :only => :show
  resources :swtor_characters, :only => :show
  
  resources :base_characters, :only => :new

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
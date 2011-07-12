Bv::Application.routes.draw do
  
  match "/search" => "search#index"

  get "status_code/invoke_404"
  
  match "/404" => "status_code#invoke_404", :as => "four_o_four"

  #Messaging
  resources :sent, :only => [:create]
  resources :messages, :only => [:destroy]
  match 'mail/sent/:id' => "sent#show", :as => "sent_mail"
  match 'mail/sent' => "sent#index", :as => "sent_mailbox"
  match 'mail/compose' => "sent#new", :as => "compose_mail"
  match 'mail/reply/:id' => "messages#reply", :as => "mail_reply"
  match 'mail/reply-all/:id' => "messages#reply_all", :as => "mail_reply_all"
  match 'mail/forward/:id' => "messages#forward", :as => "mail_forward"
  match 'mail/undelete/:id' => "messages#undelete", :as => "mail_undelete"
  match 'mail/inbox' => "mailbox#index", :as => "inbox"
  match 'mail/trash' => "mailbox#trash", :as => "trash"
  match 'mail/inbox/:id' => "messages#show", :as => "mail"
  
  #Accounts
  match "/signup" => "account#new", :as => "signup"
  match "/account" => "account#show", :as => "account"
  match "/account/edit" => "account#edit", :as => "edit_account"
  match "/account/deactivate" => "account#destroy", :as => "deactivate_account"

  #Games
  match "/game" => "games#index", :as =>"game_index"
  match "/game/:id" => "games#show", :as => "game"
  resources :games, :only => [:show, :index] do
    resources :wow_characters, :except => :index
    resources :swtor_characters, :except => :index
    resources :game_announcements, :only => [:new, :create]
  end
  resources :wow_characters, :only => :show
  resources :swtor_characters, :only => :show
  resources :base_characters, :only => :new
  
  resources :registration_answers,
    :text_box_questions,
    :radio_button_questions,
    :text_questions,
    :check_box_questions,
    :combo_box_questions,
    :answers
  
  resources :questions, :only => [ :new, :edit, :udpate, :destroy ]

  resources :registration_applications, :only => [:new, :create, :show]

  resources :page_spaces do
    resources :pages
  end  

  resources :discussion_spaces do
    resources :discussions, :controller => 'discussion_spaces/discussions', :only => [:new, :create]
  end
  
  resources :discussions, :except => [:index, :new, :create] do
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
  
  resources :announcements,
    :site_announcements,
    :game_announcements
  
  match 'announcement/acknowledge' => 'announcement_acknowledgement#new', :as => 'announcement_acknowledgement'
  
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
    resources :page_spaces,
      :discussion_spaces,
      :site_forms
      
    resources :registration_applications, :except => [:new,:create] do
      member do
        post :accept
        post :reject
      end
    end
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
  
  resources :communities
  
  resource :session
  
  match 'active_profile/:id/:type' => 'active_profiles#create', :as => :active_profile
  
  resources :communities
  
  constraints(Subdomain) do
    match '/' => "communities#show"
  end
  
  root :to => "home#index"

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
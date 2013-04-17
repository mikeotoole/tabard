DaBvRails::Application.routes.draw do

  # Stripe Callbacks
  mount StripeEvent::Engine => '/stripe-sentry'

  # Active Admin Routes
  ActiveAdmin.routes(self)

###
# Autentication Routes for Users and Admins
###
  # Routes that use no subdomain
  defaults subdomain: false do
    # Admin Users
    devise_for :admin_users, path: ActiveAdmin.application.default_namespace,
                             controllers: {sessions: 'alexandria/devise/sessions', passwords: 'alexandria/devise/passwords'},
                             path_names: { sign_in: 'login', sign_out: "logout" }
    devise_scope :admin_user do
      get "/alexandria/login" => "alexandria/devise/sessions#new"
      post "/alexandria/login" => "alexandria/devise/sessions#create"
      get "/alexandria/logout" => "alexandria/devise/sessions#destroy"
      get "/admin_users/sign_in" => "alexandria/devise/sessions#new"
      post "/admin_users/sign_in" => "alexandria/devise/sessions#create"
      get "/admin_users/password/edit" => "alexandria/devise/passwords#edit"
      put "/admin_users/password" => "alexandria/devise/passwords#update"
      get "/admin_users/password/new" => "alexandria/devise/passwords#new"
      post "/admin_users/password" => "alexandria/devise/passwords#create"
    end

    # Users
    devise_for :users, controllers: { sessions: 'sessions',
                                      registrations: 'registrations',
                                      passwords: 'passwords',
                                      confirmations: 'confirmations',
                                      unlocks: 'unlocks' }
    devise_scope :user do
      get 'login' => 'sessions#new', as: :new_user_session
      post 'login' => 'sessions#create', as: :user_session
      get 'logout' => 'sessions#destroy', as: :destroy_user_session
      get 'users/disable_confirmation' => 'registrations#disable_confirmation', as: :disable_confirmation
      get 'users/reinstate' => 'registrations#reinstate_confirmation', as: :reinstate_confirmation
      put 'users/reinstate' => 'registrations#send_reinstate', as: :send_reinstate
      get 'users/reinstate_account' => 'registrations#reinstate_account_edit', as: :reinstate_account
      put 'users/reinstate_account' => 'registrations#reinstate_account', as: :reinstate_account
      get 'account-settings' => 'registrations#edit', as: :account_settings
    end

    # Payment and Invoices
    get "card" => 'card#edit'
    put "card" => 'card#update'

    resources :subscriptions, only: :index
    get '/subscriptions/:community_id/edit' => 'subscriptions#edit', as: :edit_subscription
    put '/subscriptions/:community_id' => 'subscriptions#update', as: :subscription

    resources :invoices, only: [:index, :show], path: :statements

    # Documents
    get "users/accept_document/:id" => "document_acceptance#new", as: "accept_document"
    post "users/accept_document/:id" => "document_acceptance#create", as: "accept_document_create"

    # User Profiles
    resources :user_profiles, path: :profiles, only: [:show, :edit, :update] do
      member do
        get :activities
        get :announcements
        get :characters
        get :invites
        get :roles
      end
      resources :roles, only: [:update]
      resources :played_games, only: [:index, :show]
    end
    get "/account" => "user_profiles#account", as: "account"
    put "/account/update" => "user_profiles#update", as: "update_account"

    # Characer and PlayedGames
    resources :played_games, only: [:new, :create, :update, :destroy] do
      resource :characters, only: [:new, :create]
      collection do
        get :autocomplete
      end
    end
    resources :characters, only: [:edit, :update, :destroy]

    # Communities
    resources :communities, only: [:show, :new, :create, :destroy] do
      get 'page/:page', action: :index, on: :collection
      get 'check_name', action: :check_name, on: :collection
      member do
        get :remove_confirmation, as: "community_remove_confirmation"
      end
    end

    # Messaging
    resources :sent_messages, only: [:create]
    get 'mail/sent/autocomplete' => "sent_messages#autocomplete", as: 'sent_autocomplete'
    get 'mail/sent/:id' => "sent_messages#show", as: "sent_mail"
    get 'mail/sent' => "sent_messages#index", as: "sent_mailbox"
    get 'mail/compose' => "sent_messages#new", as: "compose_mail"
    get 'mail/compose/:id' => "sent_messages#new", as: "compose_mail_to"
    get 'mail/inbox/:id' => "messages#show", as: "mail"
    post 'mail/mark_read/:id' => "messages#mark_read", as: "mail_mark_read"
    post 'mail/mark_unread/:id' => "messages#mark_unread", as: "mail_mark_unread"
    put 'mail/:id/move/:folder_id' => "messages#move", as: "mail_move"
    put 'mail/batch_move/:folder_id' => "messages#batch_move", as: "mail_batch_move"
    put 'mail/batch_mark_read/' => "messages#batch_mark_read", as: "mail_batch_mark_read"
    put 'mail/batch_mark_unread/' => "messages#batch_mark_unread", as: "mail_batch_mark_unread"
    get 'mail/reply/:id' => "messages#reply", as: "mail_reply"
    get 'mail/reply-all/:id' => "messages#reply_all", as: "mail_reply_all"
    get 'mail/forward/:id' => "messages#forward", as: "mail_forward"
    delete 'mail/delete/:id' => "messages#destroy", as: "mail_delete"
    delete 'mail/delete' => "messages#destroy", as: "mail_delete_all"
    delete 'mail/batch_delete' => "messages#batch_destroy", as: "mail_batch_delete"
    get 'mail/inbox' => "mailbox#inbox", as: "inbox"
    get 'mail/trash' => "mailbox#trash", as: "trash"

    # Support Tickets
    resources :support_tickets, path: :support, as: :support, only: [:index, :show, :new, :create] do
      resources :support_comments, path: :comment, as: :comment, only: [:new, :create]
    end
    put 'support/:id/status/:status' => 'support_tickets#status', as: :support_status

    # Announcements
    resources :announcements, only: [:show]
    put 'announcements/batch_mark_as_seen' => "announcements#batch_mark_as_seen", as: "announcements_batch_mark_as_seen"

    # CommuntiyInvites
    resources :community_invites, only: [:create]

    # Invites
    resources :invites, only: [:show]
    put 'invites/batch_update' => "invites#batch_update", as: "invites_batch_update"

    # Artwork Upload
    resources :artwork_uploads, only: [:create, :new]

  end # end of 'defaults subdomain: false' block

  # Subdomains
  constraints(Subdomain) do
    get "/" => "subdomains#index", as: 'subdomain_home'
    scope module: "subdomains" do

      # Community
      get "/disabled" => "communities#disabled", as: "community_disabled"
      get "/community_settings" => "communities#edit", as: "edit_community_settings"
      put "/community_settings" => "communities#update", as: "update_community_settings"
      get "/clear_action_items" => "communities#clear_action_items", as: "clear_action_items"
      get "/activities" => "communities#activities", as: "community_activities"
      get "/autocomplete-members" => "communities#autocomplete_members", as: "autocomplete_members"

      # Roles and Permissions
      resources :roles, except: [:show]

      # Roster assignments
      get '/roster_assignments/pending' => 'roster_assignments#pending', as: "pending_roster_assignments"
      get '/my_roster_assignments' => 'roster_assignments#mine', as: "my_roster_assignments"
      put '/roster_assignments/batch_approve' => "roster_assignments#batch_approve", as: "batch_approve_roster_assignments"
      put '/roster_assignments/batch_reject' => "roster_assignments#batch_reject", as: "batch_reject_roster_assignments"
      delete '/roster_assignments/batch_remove' => "roster_assignments#batch_destroy", as: "batch_destroy_roster_assignments"
      resources :roster_assignments, except: [:show, :new, :edit, :update] do
        member do
          put :approve
          put :reject
        end
        collection do
          get 'game/:id' => 'roster_assignments#game', as: :game
        end
      end

      # Community profiles
      resources :community_profiles, only: [:destroy]

      # Community applications
      resources :community_applications, except: [:edit, :update] do
        member do
          post :accept
          post :reject
        end
      end

      # Custom Forms
      resources :custom_forms, except: :show do
        resources :submissions, shallow: true, only: [:index, :destroy]
        resources :submissions, except: [:update, :edit, :destroy]
        member do
          put :publish
          put :unpublish
        end
      end
      get "/custom_forms/:id/thankyou" => 'custom_forms#thankyou', as: :custom_form_thankyou

      # Discussions
      resources :comments, except: [:index, :show] do
        member do
          post :lock
          post :unlock
        end
      end
      resources :discussion_spaces do
        resources :discussions, except: [:index], shallow: true do
          member do
            post :lock
            post :unlock
          end
        end
      end

      # Announcements
      resources :announcements, except: [:edit, :update] do
        member do
          post :lock
          post :unlock
        end
        collection do
          get :community
          get 'game/:id' => 'announcements#game', as: :game
          delete 'batch_destroy' => "announcements#batch_destroy", as: "batch_destroy"
        end
      end

      # Pages
      resources :page_spaces do
        resources :pages, shallow: true, except: [:index]
      end

      # Community Games
      resources :community_games, except: [:show] do
        collection do
          get :autocomplete
        end
      end

      # Minecraft
      get 'minecraft/whitelist' => 'minecraft#whitelist', as: 'minecraft_whitelist'

      # Events
      resources :events do
        member do
          get :invites
        end
        collection do
          get :past
        end
      end
      get '/events/:year/:month' => 'events#month_index', as: "month_events"
      get '/events/:year/week/:week' => 'events#week_index', as: "week_events"

      # Invites
      put 'invites/batch_update' => "invites#batch_update", as: "invites_batch_update"
      resources :invites, only: [:edit, :update]

      resources :community_invites, only: [:index]
      post "/community_invites/mass_create" => "community_invites#mass_create"
      get "/community_invites/autocomplete" => "community_invites#autocomplete"
    end

  end # End of "constraints(Subdomain)" block

  # Routes that use no subdomain
  defaults subdomain: false do

    # Site Actions
    match "/toggle_maintenance_mode" => "site_configuration#toggle_maintenance_mode", as: :toggle_maintenance_mode

    # Top level home page
    root to: 'top_level#index'
    get "top_level/index"
    get "/bar" => "top_level#bar", as: "bar"

    # Top level pages
    get "/features" => "top_level#features", as: 'top_level_features'
    get "/pricing" => "top_level#pricing", as: 'top_level_pricing'
    get "/maintenance" => "top_level#maintenance", as: 'top_level_maintenance'
    get "/privacy-policy" => "top_level#privacy_policy", as: 'top_level_privacy_policy'
    get "/terms-of-service" => "top_level#terms_of_service", as: 'top_level_terms_of_service'
    get "/trademark-disclaimer" => "top_level#trademark_disclaimer", as: 'top_level_trademark_disclaimer'
    match "/ignore_browser" => "top_level#ignore_browser", as: 'ignore_browser'
    get "/search" => "search#index", as: 'search'
    get "/search/autocomplete" => "search#autocomplete", as: 'search_autocomplete'

    get '/robots.txt' => 'status_code#robots'

  ###
  # Verification Codes
  ###
    get '/mu-2656c9d8-02082dc2-3904fc4c-9012184b' => "status_code#blitz"
    get '/loaderio-5990c4bd3e6704d1a506c842975428c3' => "status_code#loaderio"

    # Error Handling and Testing
    get 'bang' => 'status_code#bang' # Test errors

    get "/unsupported_browser" => "status_code#unsupported_browser", as: 'unsupported_browser'
    match '/not_found' => 'status_code#not_found', as: 'not_found'
    match '/forbidden' => 'status_code#forbidden', as: 'forbidden'
    match '/internal_server_error' => 'status_code#internal_server_error', as: 'internal_server_error'

    match "/404", to: "status_code#not_found"
    match "/500", to: "status_code#internal_server_error"

  end # End of 'defaults subdomain: false' block

end
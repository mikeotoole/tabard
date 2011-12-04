DaBvRails::Application.routes.draw do
  # Admin Users
  ActiveAdmin.routes(self)
  devise_for :admin_users do match "/admin/login" => "admin/devise/sessions#new" end
  devise_for :admin_users , ActiveAdmin::Devise.config

  # Users
  devise_for :users, :controllers => { :sessions => 'sessions', :registrations => 'registrations' }
  match '/dashboard' => 'user_profiles#index', :as => 'user_root'

  # Site Actions
  put "/toggle_maintenance_mode" => "site_action#toggle_maintenance_mode", :as => :toggle_maintenance_mode

  # Documents
  get "/accept_document/:id" => "document_acceptance#new", :as => "accept_document"
  post "/accept_document/:id" => "document_acceptance#create", :as => "accept_document_create"

  resources :documents

  # User Profiles
  resources :user_profiles, :only => [:show, :edit, :update, :index, :account]
  get "/account" => "user_profiles#account", :as => "account"
  match "/account/update" => "user_profiles#update", :as => "update_account", :via => :put

  # Active profile
  resource :active_profiles, :only => [:create]
  post 'active_profile/:id/:type' => 'active_profiles#create', :as => :active_profile

  # Communities
  resources :communities, :except => [:destroy, :update, :edit]

  # Games
  get "/star-wars-the-old-republic" => 'swtors#index', :as => 'swtors'
  get "/world-of-warcraft" => 'wows#index', :as => 'wows'

  # Characters
  resources :wow_characters, :except => [:index, :create]
  post 'wow_characters/new' => 'wow_characters#create', :as => :wow_characters
  resources :swtor_characters, :except => [:index, :create]
  post 'swtor_characters/new' => 'swtor_characters#create', :as => :swtor_characters

  # Messaging
  resources :sent_messages, :only => [:create]
  get 'mail/sent/:id' => "sent_messages#show", :as => "sent_mail"
  get 'mail/sent' => "sent_messages#index", :as => "sent_mailbox"
  get 'mail/compose' => "sent_messages#new", :as => "compose_mail"
  get 'mail/compose/:id' => "sent_messages#new", :as => "compose_mail_to"
  get 'mail/inbox/:id' => "messages#show", :as => "mail"
  post 'mail/mark_read/:id' => "messages#mark_read", :as => "mail_mark_read"
  post 'mail/mark_unread/:id' => "messages#mark_unread", :as => "mail_mark_unread"
  put 'mail/:id/move/:folder_id' => "messages#move", :as => "mail_move"
  put 'mail/batch_move/:folder_id' => "messages#batch_move", :as => "mail_batch_move"
  put 'mail/batch_mark_read/' => "messages#batch_mark_read", :as => "mail_batch_mark_read"
  put 'mail/batch_mark_unread/' => "messages#batch_mark_unread", :as => "mail_batch_mark_unread"
  get 'mail/reply/:id' => "messages#reply", :as => "mail_reply"
  get 'mail/reply-all/:id' => "messages#reply_all", :as => "mail_reply_all"
  get 'mail/forward/:id' => "messages#forward", :as => "mail_forward"
  delete 'mail/delete/:id' => "messages#destroy", :as => "mail_delete"
  delete 'mail/delete' => "messages#destroy", :as => "mail_delete_all"
  delete 'mail/batch_delete' => "messages#batch_destroy", :as => "mail_batch_delete"
  get 'mail/inbox' => "mailbox#inbox", :as => "inbox"
  get 'mail/trash' => "mailbox#trash", :as => "trash"

  # Announcements
  resources :announcements, :only => [:index]
  put 'announcements/batch_mark_as_seen/' => "announcements#batch_mark_as_seen", :as => "announcements_batch_mark_as_seen"

  # Subdomains
  constraints(Subdomain) do
    get "/" => "subdomains#index", :as => 'subdomain_home'
    scope :module => "subdomains" do

      # Community edit/update
      get "/community_settings" => "communities#edit", :as => "edit_community_settings"
      match "/community_settings" => "communities#update", :as => "update_community_settings", :via => :put
      resources :communities, :only => [:edit, :update]

      # Roles and Permissions
      resources :roles do
        resources :permissions
      end

      # Roster assignments
      get '/roster_assignments/pending' => 'roster_assignments#pending', :as => "pending_roster_assignments"
      get '/my_roster_assignments' => 'roster_assignments#mine', :as => "my_roster_assignments"
      put '/roster_assignments/batch_approve' => "roster_assignments#batch_approve", :as => "batch_approve_roster_assignments"
      put '/roster_assignments/batch_reject' => "roster_assignments#batch_reject", :as => "batch_reject_roster_assignments"
      delete '/roster_assignments/batch_remove' => "roster_assignments#batch_destroy", :as => "batch_destroy_roster_assignments"
      resources :roster_assignments, :except => [:show, :new] do
        member do
          put :approve
          put :reject
        end
      end

      # Community applications
      resources :community_applications, :except => [:edit, :update] do
        member do
          post :accept
          post :reject
        end
      end

      # Custom Forms
      resources :custom_forms, :except => :show do
        resources :questions, :shallow => true
        resources :submissions, :shallow => true, :only => [:index, :destroy]
        resources :submissions, :except => [:update, :edit, :destroy] do
          resources :answers, :except => [:update, :edit, :destroy]
        end
      end

      # Discussions
      resources :comments, :except => [:index, :show] do
        member do
          post :lock
          post :unlock
        end
      end
      resources :discussion_spaces do
        resources :discussions, :except => [:index], :shallow => true do
          member do
            post :lock
            post :unlock
          end
        end
      end

      # Announcements
      resources :announcement_spaces, :only => [:index, :show] do
        resources :announcements, :except => [:index], :shallow => true do
          member do
            post :lock
            post :unlock
          end
        end
      end

      # Pages
      resources :page_spaces do
        resources :pages, :shallow => true
      end

      # Supported Games
      resources :supported_games
    end
  end

  # Top level home page
  root :to => 'top_level#index'
  get "top_level/index"

  # Top level pages
  get "/intro" => "top_level#intro", :as => 'top_level_intro'
  get "/features" => "top_level#features", :as => 'top_level_features'
  get "/pricing" => "top_level#pricing", :as => 'top_level_pricing'
  get "/maintenance" => "top_level#maintenance", :as => 'top_level_maintenance'
  get "/privacy-policy" => "top_level#privacy_policy", :as => 'top_level_privacy_policy'
  get "/terms-of-service" => "top_level#terms_of_service", :as => 'top_level_terms_of_service'

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
# Generated on 03 Dec 2011 16:41
#
#                          admin_comments GET    /admin/comments(.:format)                                                      {:action=>"index", :controller=>"admin/comments"}
#                                         POST   /admin/comments(.:format)                                                      {:action=>"create", :controller=>"admin/comments"}
#                       new_admin_comment GET    /admin/comments/new(.:format)                                                  {:action=>"new", :controller=>"admin/comments"}
#                      edit_admin_comment GET    /admin/comments/:id/edit(.:format)                                             {:action=>"edit", :controller=>"admin/comments"}
#                           admin_comment GET    /admin/comments/:id(.:format)                                                  {:action=>"show", :controller=>"admin/comments"}
#                                         PUT    /admin/comments/:id(.:format)                                                  {:action=>"update", :controller=>"admin/comments"}
#                                         DELETE /admin/comments/:id(.:format)                                                  {:action=>"destroy", :controller=>"admin/comments"}
#         reset_password_admin_admin_user PUT    /admin/admin_users/:id/reset_password(.:format)                                {:action=>"reset_password", :controller=>"admin/admin_users"}
#          edit_account_admin_admin_users GET    /admin/admin_users/edit_account(.:format)                                      {:action=>"edit_account", :controller=>"admin/admin_users"}
#        update_account_admin_admin_users PUT    /admin/admin_users/update_account(.:format)                                    {:action=>"update_account", :controller=>"admin/admin_users"}
#   reset_all_passwords_admin_admin_users POST   /admin/admin_users/reset_all_passwords(.:format)                               {:action=>"reset_all_passwords", :controller=>"admin/admin_users"}
#                       admin_admin_users GET    /admin/admin_users(.:format)                                                   {:action=>"index", :controller=>"admin/admin_users"}
#                                         POST   /admin/admin_users(.:format)                                                   {:action=>"create", :controller=>"admin/admin_users"}
#                    new_admin_admin_user GET    /admin/admin_users/new(.:format)                                               {:action=>"new", :controller=>"admin/admin_users"}
#                   edit_admin_admin_user GET    /admin/admin_users/:id/edit(.:format)                                          {:action=>"edit", :controller=>"admin/admin_users"}
#                        admin_admin_user GET    /admin/admin_users/:id(.:format)                                               {:action=>"show", :controller=>"admin/admin_users"}
#                                         PUT    /admin/admin_users/:id(.:format)                                               {:action=>"update", :controller=>"admin/admin_users"}
#                                         DELETE /admin/admin_users/:id(.:format)                                               {:action=>"destroy", :controller=>"admin/admin_users"}
#                       admin_communities GET    /admin/communities(.:format)                                                   {:action=>"index", :controller=>"admin/communities"}
#                                         POST   /admin/communities(.:format)                                                   {:action=>"create", :controller=>"admin/communities"}
#                     new_admin_community GET    /admin/communities/new(.:format)                                               {:action=>"new", :controller=>"admin/communities"}
#                    edit_admin_community GET    /admin/communities/:id/edit(.:format)                                          {:action=>"edit", :controller=>"admin/communities"}
#                         admin_community GET    /admin/communities/:id(.:format)                                               {:action=>"show", :controller=>"admin/communities"}
#                                         PUT    /admin/communities/:id(.:format)                                               {:action=>"update", :controller=>"admin/communities"}
#                                         DELETE /admin/communities/:id(.:format)                                               {:action=>"destroy", :controller=>"admin/communities"}
#       delete_question_admin_custom_form PUT    /admin/custom_forms/:id/delete_question(.:format)                              {:action=>"delete_question", :controller=>"admin/custom_forms"}
#                      admin_custom_forms GET    /admin/custom_forms(.:format)                                                  {:action=>"index", :controller=>"admin/custom_forms"}
#                                         POST   /admin/custom_forms(.:format)                                                  {:action=>"create", :controller=>"admin/custom_forms"}
#                   new_admin_custom_form GET    /admin/custom_forms/new(.:format)                                              {:action=>"new", :controller=>"admin/custom_forms"}
#                  edit_admin_custom_form GET    /admin/custom_forms/:id/edit(.:format)                                         {:action=>"edit", :controller=>"admin/custom_forms"}
#                       admin_custom_form GET    /admin/custom_forms/:id(.:format)                                              {:action=>"show", :controller=>"admin/custom_forms"}
#                                         PUT    /admin/custom_forms/:id(.:format)                                              {:action=>"update", :controller=>"admin/custom_forms"}
#                                         DELETE /admin/custom_forms/:id(.:format)                                              {:action=>"destroy", :controller=>"admin/custom_forms"}
#                 admin_discussion_spaces GET    /admin/discussion_spaces(.:format)                                             {:action=>"index", :controller=>"admin/discussion_spaces"}
#                                         POST   /admin/discussion_spaces(.:format)                                             {:action=>"create", :controller=>"admin/discussion_spaces"}
#              new_admin_discussion_space GET    /admin/discussion_spaces/new(.:format)                                         {:action=>"new", :controller=>"admin/discussion_spaces"}
#             edit_admin_discussion_space GET    /admin/discussion_spaces/:id/edit(.:format)                                    {:action=>"edit", :controller=>"admin/discussion_spaces"}
#                  admin_discussion_space GET    /admin/discussion_spaces/:id(.:format)                                         {:action=>"show", :controller=>"admin/discussion_spaces"}
#                                         PUT    /admin/discussion_spaces/:id(.:format)                                         {:action=>"update", :controller=>"admin/discussion_spaces"}
#                                         DELETE /admin/discussion_spaces/:id(.:format)                                         {:action=>"destroy", :controller=>"admin/discussion_spaces"}
#         remove_comment_admin_discussion PUT    /admin/discussions/:id/remove_comment(.:format)                                {:action=>"remove_comment", :controller=>"admin/discussions"}
#                       admin_discussions GET    /admin/discussions(.:format)                                                   {:action=>"index", :controller=>"admin/discussions"}
#                                         POST   /admin/discussions(.:format)                                                   {:action=>"create", :controller=>"admin/discussions"}
#                    new_admin_discussion GET    /admin/discussions/new(.:format)                                               {:action=>"new", :controller=>"admin/discussions"}
#                   edit_admin_discussion GET    /admin/discussions/:id/edit(.:format)                                          {:action=>"edit", :controller=>"admin/discussions"}
#                        admin_discussion GET    /admin/discussions/:id(.:format)                                               {:action=>"show", :controller=>"admin/discussions"}
#                                         PUT    /admin/discussions/:id(.:format)                                               {:action=>"update", :controller=>"admin/discussions"}
#                                         DELETE /admin/discussions/:id(.:format)                                               {:action=>"destroy", :controller=>"admin/discussions"}
#            view_document_admin_document GET    /admin/documents/:id/view_document(.:format)                                   {:action=>"view_document", :controller=>"admin/documents"}
#                         admin_documents GET    /admin/documents(.:format)                                                     {:action=>"index", :controller=>"admin/documents"}
#                                         POST   /admin/documents(.:format)                                                     {:action=>"create", :controller=>"admin/documents"}
#                      new_admin_document GET    /admin/documents/new(.:format)                                                 {:action=>"new", :controller=>"admin/documents"}
#                     edit_admin_document GET    /admin/documents/:id/edit(.:format)                                            {:action=>"edit", :controller=>"admin/documents"}
#                          admin_document GET    /admin/documents/:id(.:format)                                                 {:action=>"show", :controller=>"admin/documents"}
#                                         PUT    /admin/documents/:id(.:format)                                                 {:action=>"update", :controller=>"admin/documents"}
#                                         DELETE /admin/documents/:id(.:format)                                                 {:action=>"destroy", :controller=>"admin/documents"}
#                       admin_page_spaces GET    /admin/page_spaces(.:format)                                                   {:action=>"index", :controller=>"admin/page_spaces"}
#                                         POST   /admin/page_spaces(.:format)                                                   {:action=>"create", :controller=>"admin/page_spaces"}
#                    new_admin_page_space GET    /admin/page_spaces/new(.:format)                                               {:action=>"new", :controller=>"admin/page_spaces"}
#                   edit_admin_page_space GET    /admin/page_spaces/:id/edit(.:format)                                          {:action=>"edit", :controller=>"admin/page_spaces"}
#                        admin_page_space GET    /admin/page_spaces/:id(.:format)                                               {:action=>"show", :controller=>"admin/page_spaces"}
#                                         PUT    /admin/page_spaces/:id(.:format)                                               {:action=>"update", :controller=>"admin/page_spaces"}
#                                         DELETE /admin/page_spaces/:id(.:format)                                               {:action=>"destroy", :controller=>"admin/page_spaces"}
#                             admin_pages GET    /admin/pages(.:format)                                                         {:action=>"index", :controller=>"admin/pages"}
#                                         POST   /admin/pages(.:format)                                                         {:action=>"create", :controller=>"admin/pages"}
#                          new_admin_page GET    /admin/pages/new(.:format)                                                     {:action=>"new", :controller=>"admin/pages"}
#                         edit_admin_page GET    /admin/pages/:id/edit(.:format)                                                {:action=>"edit", :controller=>"admin/pages"}
#                              admin_page GET    /admin/pages/:id(.:format)                                                     {:action=>"show", :controller=>"admin/pages"}
#                                         PUT    /admin/pages/:id(.:format)                                                     {:action=>"update", :controller=>"admin/pages"}
#                                         DELETE /admin/pages/:id(.:format)                                                     {:action=>"destroy", :controller=>"admin/pages"}
# delete_predefined_answer_admin_question PUT    /admin/questions/:id/delete_predefined_answer(.:format)                        {:action=>"delete_predefined_answer", :controller=>"admin/questions"}
#                         admin_questions GET    /admin/questions(.:format)                                                     {:action=>"index", :controller=>"admin/questions"}
#                                         POST   /admin/questions(.:format)                                                     {:action=>"create", :controller=>"admin/questions"}
#                      new_admin_question GET    /admin/questions/new(.:format)                                                 {:action=>"new", :controller=>"admin/questions"}
#                     edit_admin_question GET    /admin/questions/:id/edit(.:format)                                            {:action=>"edit", :controller=>"admin/questions"}
#                          admin_question GET    /admin/questions/:id(.:format)                                                 {:action=>"show", :controller=>"admin/questions"}
#                                         PUT    /admin/questions/:id(.:format)                                                 {:action=>"update", :controller=>"admin/questions"}
#                                         DELETE /admin/questions/:id(.:format)                                                 {:action=>"destroy", :controller=>"admin/questions"}
#                    admin_supported_game PUT    /admin/supported_games/:id(.:format)                                           {:action=>"update", :controller=>"admin/supported_games"}
#                   admin_supported_games GET    /admin/supported_games(.:format)                                               {:action=>"index", :controller=>"admin/supported_games"}
#                                         POST   /admin/supported_games(.:format)                                               {:action=>"create", :controller=>"admin/supported_games"}
#                new_admin_supported_game GET    /admin/supported_games/new(.:format)                                           {:action=>"new", :controller=>"admin/supported_games"}
#               edit_admin_supported_game GET    /admin/supported_games/:id/edit(.:format)                                      {:action=>"edit", :controller=>"admin/supported_games"}
#                                         GET    /admin/supported_games/:id(.:format)                                           {:action=>"show", :controller=>"admin/supported_games"}
#                                         PUT    /admin/supported_games/:id(.:format)                                           {:action=>"update", :controller=>"admin/supported_games"}
#                                         DELETE /admin/supported_games/:id(.:format)                                           {:action=>"destroy", :controller=>"admin/supported_games"}
#                  admin_swtor_characters GET    /admin/swtor_characters(.:format)                                              {:action=>"index", :controller=>"admin/swtor_characters"}
#                                         POST   /admin/swtor_characters(.:format)                                              {:action=>"create", :controller=>"admin/swtor_characters"}
#               new_admin_swtor_character GET    /admin/swtor_characters/new(.:format)                                          {:action=>"new", :controller=>"admin/swtor_characters"}
#              edit_admin_swtor_character GET    /admin/swtor_characters/:id/edit(.:format)                                     {:action=>"edit", :controller=>"admin/swtor_characters"}
#                   admin_swtor_character GET    /admin/swtor_characters/:id(.:format)                                          {:action=>"show", :controller=>"admin/swtor_characters"}
#                                         PUT    /admin/swtor_characters/:id(.:format)                                          {:action=>"update", :controller=>"admin/swtor_characters"}
#                                         DELETE /admin/swtor_characters/:id(.:format)                                          {:action=>"destroy", :controller=>"admin/swtor_characters"}
#                            admin_swtors GET    /admin/swtors(.:format)                                                        {:action=>"index", :controller=>"admin/swtors"}
#                                         POST   /admin/swtors(.:format)                                                        {:action=>"create", :controller=>"admin/swtors"}
#                         new_admin_swtor GET    /admin/swtors/new(.:format)                                                    {:action=>"new", :controller=>"admin/swtors"}
#                        edit_admin_swtor GET    /admin/swtors/:id/edit(.:format)                                               {:action=>"edit", :controller=>"admin/swtors"}
#                             admin_swtor GET    /admin/swtors/:id(.:format)                                                    {:action=>"show", :controller=>"admin/swtors"}
#                                         PUT    /admin/swtors/:id(.:format)                                                    {:action=>"update", :controller=>"admin/swtors"}
#                                         DELETE /admin/swtors/:id(.:format)                                                    {:action=>"destroy", :controller=>"admin/swtors"}
#                     admin_user_profiles GET    /admin/user_profiles(.:format)                                                 {:action=>"index", :controller=>"admin/user_profiles"}
#                                         POST   /admin/user_profiles(.:format)                                                 {:action=>"create", :controller=>"admin/user_profiles"}
#                  new_admin_user_profile GET    /admin/user_profiles/new(.:format)                                             {:action=>"new", :controller=>"admin/user_profiles"}
#                 edit_admin_user_profile GET    /admin/user_profiles/:id/edit(.:format)                                        {:action=>"edit", :controller=>"admin/user_profiles"}
#                      admin_user_profile GET    /admin/user_profiles/:id(.:format)                                             {:action=>"show", :controller=>"admin/user_profiles"}
#                                         PUT    /admin/user_profiles/:id(.:format)                                             {:action=>"update", :controller=>"admin/user_profiles"}
#                                         DELETE /admin/user_profiles/:id(.:format)                                             {:action=>"destroy", :controller=>"admin/user_profiles"}
#                      suspend_admin_user PUT    /admin/users/:id/suspend(.:format)                                             {:action=>"suspend", :controller=>"admin/users"}
#                    reinstate_admin_user PUT    /admin/users/:id/reinstate(.:format)                                           {:action=>"reinstate", :controller=>"admin/users"}
#               reset_password_admin_user PUT    /admin/users/:id/reset_password(.:format)                                      {:action=>"reset_password", :controller=>"admin/users"}
#         reset_all_passwords_admin_users POST   /admin/users/reset_all_passwords(.:format)                                     {:action=>"reset_all_passwords", :controller=>"admin/users"}
#          sign_out_all_users_admin_users POST   /admin/users/sign_out_all_users(.:format)                                      {:action=>"sign_out_all_users", :controller=>"admin/users"}
#                             admin_users GET    /admin/users(.:format)                                                         {:action=>"index", :controller=>"admin/users"}
#                                         POST   /admin/users(.:format)                                                         {:action=>"create", :controller=>"admin/users"}
#                          new_admin_user GET    /admin/users/new(.:format)                                                     {:action=>"new", :controller=>"admin/users"}
#                         edit_admin_user GET    /admin/users/:id/edit(.:format)                                                {:action=>"edit", :controller=>"admin/users"}
#                              admin_user GET    /admin/users/:id(.:format)                                                     {:action=>"show", :controller=>"admin/users"}
#                                         PUT    /admin/users/:id(.:format)                                                     {:action=>"update", :controller=>"admin/users"}
#                                         DELETE /admin/users/:id(.:format)                                                     {:action=>"destroy", :controller=>"admin/users"}
#                    admin_wow_characters GET    /admin/wow_characters(.:format)                                                {:action=>"index", :controller=>"admin/wow_characters"}
#                                         POST   /admin/wow_characters(.:format)                                                {:action=>"create", :controller=>"admin/wow_characters"}
#                 new_admin_wow_character GET    /admin/wow_characters/new(.:format)                                            {:action=>"new", :controller=>"admin/wow_characters"}
#                edit_admin_wow_character GET    /admin/wow_characters/:id/edit(.:format)                                       {:action=>"edit", :controller=>"admin/wow_characters"}
#                     admin_wow_character GET    /admin/wow_characters/:id(.:format)                                            {:action=>"show", :controller=>"admin/wow_characters"}
#                                         PUT    /admin/wow_characters/:id(.:format)                                            {:action=>"update", :controller=>"admin/wow_characters"}
#                                         DELETE /admin/wow_characters/:id(.:format)                                            {:action=>"destroy", :controller=>"admin/wow_characters"}
#                              admin_wows GET    /admin/wows(.:format)                                                          {:action=>"index", :controller=>"admin/wows"}
#                                         POST   /admin/wows(.:format)                                                          {:action=>"create", :controller=>"admin/wows"}
#                           new_admin_wow GET    /admin/wows/new(.:format)                                                      {:action=>"new", :controller=>"admin/wows"}
#                          edit_admin_wow GET    /admin/wows/:id/edit(.:format)                                                 {:action=>"edit", :controller=>"admin/wows"}
#                               admin_wow GET    /admin/wows/:id(.:format)                                                      {:action=>"show", :controller=>"admin/wows"}
#                                         PUT    /admin/wows/:id(.:format)                                                      {:action=>"update", :controller=>"admin/wows"}
#                                         DELETE /admin/wows/:id(.:format)                                                      {:action=>"destroy", :controller=>"admin/wows"}
#                             admin_login        /admin/login(.:format)                                                         {:controller=>"admin/devise/sessions", :action=>"new"}
#                  new_admin_user_session GET    /admin_users/sign_in(.:format)                                                 {:action=>"new", :controller=>"devise/sessions"}
#                      admin_user_session POST   /admin_users/sign_in(.:format)                                                 {:action=>"create", :controller=>"devise/sessions"}
#              destroy_admin_user_session GET    /admin_users/sign_out(.:format)                                                {:action=>"destroy", :controller=>"devise/sessions"}
#                     admin_user_password POST   /admin_users/password(.:format)                                                {:action=>"create", :controller=>"devise/passwords"}
#                 new_admin_user_password GET    /admin_users/password/new(.:format)                                            {:action=>"new", :controller=>"devise/passwords"}
#                edit_admin_user_password GET    /admin_users/password/edit(.:format)                                           {:action=>"edit", :controller=>"devise/passwords"}
#                                         PUT    /admin_users/password(.:format)                                                {:action=>"update", :controller=>"devise/passwords"}
#                       admin_user_unlock POST   /admin_users/unlock(.:format)                                                  {:action=>"create", :controller=>"devise/unlocks"}
#                   new_admin_user_unlock GET    /admin_users/unlock/new(.:format)                                              {:action=>"new", :controller=>"devise/unlocks"}
#                                         GET    /admin_users/unlock(.:format)                                                  {:action=>"show", :controller=>"devise/unlocks"}
#                  new_admin_user_session GET    /admin/login(.:format)                                                         {:action=>"new", :controller=>"active_admin/devise/sessions"}
#                                         POST   /admin/login(.:format)                                                         {:action=>"create", :controller=>"active_admin/devise/sessions"}
#              destroy_admin_user_session GET    /admin/logout(.:format)                                                        {:action=>"destroy", :controller=>"active_admin/devise/sessions"}
#                                         POST   /admin/password(.:format)                                                      {:action=>"create", :controller=>"active_admin/devise/passwords"}
#                                         GET    /admin/password/new(.:format)                                                  {:action=>"new", :controller=>"active_admin/devise/passwords"}
#                                         GET    /admin/password/edit(.:format)                                                 {:action=>"edit", :controller=>"active_admin/devise/passwords"}
#                                         PUT    /admin/password(.:format)                                                      {:action=>"update", :controller=>"active_admin/devise/passwords"}
#                                         POST   /admin/unlock(.:format)                                                        {:action=>"create", :controller=>"devise/unlocks"}
#                                         GET    /admin/unlock/new(.:format)                                                    {:action=>"new", :controller=>"devise/unlocks"}
#                                         GET    /admin/unlock(.:format)                                                        {:action=>"show", :controller=>"devise/unlocks"}
#                        new_user_session GET    /users/sign_in(.:format)                                                       {:action=>"new", :controller=>"sessions"}
#                            user_session POST   /users/sign_in(.:format)                                                       {:action=>"create", :controller=>"sessions"}
#                    destroy_user_session GET    /users/sign_out(.:format)                                                      {:action=>"destroy", :controller=>"sessions"}
#                           user_password POST   /users/password(.:format)                                                      {:action=>"create", :controller=>"devise/passwords"}
#                       new_user_password GET    /users/password/new(.:format)                                                  {:action=>"new", :controller=>"devise/passwords"}
#                      edit_user_password GET    /users/password/edit(.:format)                                                 {:action=>"edit", :controller=>"devise/passwords"}
#                                         PUT    /users/password(.:format)                                                      {:action=>"update", :controller=>"devise/passwords"}
#                cancel_user_registration GET    /users/cancel(.:format)                                                        {:action=>"cancel", :controller=>"registrations"}
#                       user_registration POST   /users(.:format)                                                               {:action=>"create", :controller=>"registrations"}
#                   new_user_registration GET    /users/sign_up(.:format)                                                       {:action=>"new", :controller=>"registrations"}
#                  edit_user_registration GET    /users/edit(.:format)                                                          {:action=>"edit", :controller=>"registrations"}
#                                         PUT    /users(.:format)                                                               {:action=>"update", :controller=>"registrations"}
#                                         DELETE /users(.:format)                                                               {:action=>"destroy", :controller=>"registrations"}
#                       user_confirmation POST   /users/confirmation(.:format)                                                  {:action=>"create", :controller=>"devise/confirmations"}
#                   new_user_confirmation GET    /users/confirmation/new(.:format)                                              {:action=>"new", :controller=>"devise/confirmations"}
#                                         GET    /users/confirmation(.:format)                                                  {:action=>"show", :controller=>"devise/confirmations"}
#                             user_unlock POST   /users/unlock(.:format)                                                        {:action=>"create", :controller=>"devise/unlocks"}
#                         new_user_unlock GET    /users/unlock/new(.:format)                                                    {:action=>"new", :controller=>"devise/unlocks"}
#                                         GET    /users/unlock(.:format)                                                        {:action=>"show", :controller=>"devise/unlocks"}
#                               user_root        /dashboard(.:format)                                                           {:controller=>"user_profiles", :action=>"index"}
#                 toggle_maintenance_mode PUT    /toggle_maintenance_mode(.:format)                                             {:controller=>"site_action", :action=>"toggle_maintenance_mode"}
#                         accept_document GET    /accept_document/:id(.:format)                                                 {:controller=>"document_acceptance", :action=>"new"}
#                  accept_document_create POST   /accept_document/:id(.:format)                                                 {:controller=>"document_acceptance", :action=>"create"}
#                               documents GET    /documents(.:format)                                                           {:action=>"index", :controller=>"documents"}
#                                         POST   /documents(.:format)                                                           {:action=>"create", :controller=>"documents"}
#                            new_document GET    /documents/new(.:format)                                                       {:action=>"new", :controller=>"documents"}
#                           edit_document GET    /documents/:id/edit(.:format)                                                  {:action=>"edit", :controller=>"documents"}
#                                document GET    /documents/:id(.:format)                                                       {:action=>"show", :controller=>"documents"}
#                                         PUT    /documents/:id(.:format)                                                       {:action=>"update", :controller=>"documents"}
#                                         DELETE /documents/:id(.:format)                                                       {:action=>"destroy", :controller=>"documents"}
#                           user_profiles GET    /user_profiles(.:format)                                                       {:action=>"index", :controller=>"user_profiles"}
#                       edit_user_profile GET    /user_profiles/:id/edit(.:format)                                              {:action=>"edit", :controller=>"user_profiles"}
#                            user_profile GET    /user_profiles/:id(.:format)                                                   {:action=>"show", :controller=>"user_profiles"}
#                                         PUT    /user_profiles/:id(.:format)                                                   {:action=>"update", :controller=>"user_profiles"}
#                                 account GET    /account(.:format)                                                             {:controller=>"user_profiles", :action=>"account"}
#                          update_account PUT    /account/update(.:format)                                                      {:controller=>"user_profiles", :action=>"update"}
#                         active_profiles POST   /active_profiles(.:format)                                                     {:action=>"create", :controller=>"active_profiles"}
#                          active_profile POST   /active_profile/:id/:type(.:format)                                            {:controller=>"active_profiles", :action=>"create"}
#                             communities GET    /communities(.:format)                                                         {:action=>"index", :controller=>"communities"}
#                           new_community GET    /communities/new(.:format)                                                     {:action=>"new", :controller=>"communities"}
#                               community GET    /communities/:id(.:format)                                                     {:action=>"show", :controller=>"communities"}
#                             communities POST   /communities/new(.:format)                                                     {:controller=>"communities", :action=>"create"}
#                                  swtors GET    /star-wars-the-old-republic(.:format)                                          {:controller=>"swtors", :action=>"index"}
#                                    wows GET    /world-of-warcraft(.:format)                                                   {:controller=>"wows", :action=>"index"}
#                       new_wow_character GET    /wow_characters/new(.:format)                                                  {:action=>"new", :controller=>"wow_characters"}
#                      edit_wow_character GET    /wow_characters/:id/edit(.:format)                                             {:action=>"edit", :controller=>"wow_characters"}
#                           wow_character GET    /wow_characters/:id(.:format)                                                  {:action=>"show", :controller=>"wow_characters"}
#                                         PUT    /wow_characters/:id(.:format)                                                  {:action=>"update", :controller=>"wow_characters"}
#                                         DELETE /wow_characters/:id(.:format)                                                  {:action=>"destroy", :controller=>"wow_characters"}
#                          wow_characters POST   /wow_characters/new(.:format)                                                  {:controller=>"wow_characters", :action=>"create"}
#                     new_swtor_character GET    /swtor_characters/new(.:format)                                                {:action=>"new", :controller=>"swtor_characters"}
#                    edit_swtor_character GET    /swtor_characters/:id/edit(.:format)                                           {:action=>"edit", :controller=>"swtor_characters"}
#                         swtor_character GET    /swtor_characters/:id(.:format)                                                {:action=>"show", :controller=>"swtor_characters"}
#                                         PUT    /swtor_characters/:id(.:format)                                                {:action=>"update", :controller=>"swtor_characters"}
#                                         DELETE /swtor_characters/:id(.:format)                                                {:action=>"destroy", :controller=>"swtor_characters"}
#                        swtor_characters POST   /swtor_characters/new(.:format)                                                {:controller=>"swtor_characters", :action=>"create"}
#                           sent_messages POST   /sent_messages(.:format)                                                       {:action=>"create", :controller=>"sent_messages"}
#                               sent_mail GET    /mail/sent/:id(.:format)                                                       {:controller=>"sent_messages", :action=>"show"}
#                            sent_mailbox GET    /mail/sent(.:format)                                                           {:controller=>"sent_messages", :action=>"index"}
#                            compose_mail GET    /mail/compose(.:format)                                                        {:controller=>"sent_messages", :action=>"new"}
#                         compose_mail_to GET    /mail/compose/:id(.:format)                                                    {:controller=>"sent_messages", :action=>"new"}
#                                    mail GET    /mail/inbox/:id(.:format)                                                      {:controller=>"messages", :action=>"show"}
#                          mail_mark_read POST   /mail/mark_read/:id(.:format)                                                  {:controller=>"messages", :action=>"mark_read"}
#                        mail_mark_unread POST   /mail/mark_unread/:id(.:format)                                                {:controller=>"messages", :action=>"mark_unread"}
#                               mail_move PUT    /mail/:id/move/:folder_id(.:format)                                            {:controller=>"messages", :action=>"move"}
#                         mail_batch_move PUT    /mail/batch_move/:folder_id(.:format)                                          {:controller=>"messages", :action=>"batch_move"}
#                    mail_batch_mark_read PUT    /mail/batch_mark_read(.:format)                                                {:controller=>"messages", :action=>"batch_mark_read"}
#                  mail_batch_mark_unread PUT    /mail/batch_mark_unread(.:format)                                              {:controller=>"messages", :action=>"batch_mark_unread"}
#                              mail_reply GET    /mail/reply/:id(.:format)                                                      {:controller=>"messages", :action=>"reply"}
#                          mail_reply_all GET    /mail/reply-all/:id(.:format)                                                  {:controller=>"messages", :action=>"reply_all"}
#                            mail_forward GET    /mail/forward/:id(.:format)                                                    {:controller=>"messages", :action=>"forward"}
#                             mail_delete DELETE /mail/delete/:id(.:format)                                                     {:controller=>"messages", :action=>"destroy"}
#                         mail_delete_all DELETE /mail/delete(.:format)                                                         {:controller=>"messages", :action=>"destroy"}
#                       mail_batch_delete DELETE /mail/batch_delete(.:format)                                                   {:controller=>"messages", :action=>"batch_destroy"}
#                                   inbox GET    /mail/inbox(.:format)                                                          {:controller=>"mailbox", :action=>"inbox"}
#                                   trash GET    /mail/trash(.:format)                                                          {:controller=>"mailbox", :action=>"trash"}
#                           announcements GET    /announcements(.:format)                                                       {:action=>"index", :controller=>"announcements"}
#        announcements_batch_mark_as_seen PUT    /announcements/batch_mark_as_seen(.:format)                                    {:controller=>"announcements", :action=>"batch_mark_as_seen"}
#                          subdomain_home GET    /                                                                              {:controller=>"subdomains", :action=>"index"}
#                 edit_community_settings GET    /community_settings(.:format)                                                  {:controller=>"subdomains/communities", :action=>"edit"}
#               update_community_settings PUT    /community_settings(.:format)                                                  {:controller=>"subdomains/communities", :action=>"update"}
#                          edit_community GET    /communities/:id/edit(.:format)                                                {:action=>"edit", :controller=>"subdomains/communities"}
#                                         PUT    /communities/:id(.:format)                                                     {:action=>"update", :controller=>"subdomains/communities"}
#                        role_permissions GET    /roles/:role_id/permissions(.:format)                                          {:action=>"index", :controller=>"subdomains/permissions"}
#                                         POST   /roles/:role_id/permissions(.:format)                                          {:action=>"create", :controller=>"subdomains/permissions"}
#                     new_role_permission GET    /roles/:role_id/permissions/new(.:format)                                      {:action=>"new", :controller=>"subdomains/permissions"}
#                    edit_role_permission GET    /roles/:role_id/permissions/:id/edit(.:format)                                 {:action=>"edit", :controller=>"subdomains/permissions"}
#                         role_permission GET    /roles/:role_id/permissions/:id(.:format)                                      {:action=>"show", :controller=>"subdomains/permissions"}
#                                         PUT    /roles/:role_id/permissions/:id(.:format)                                      {:action=>"update", :controller=>"subdomains/permissions"}
#                                         DELETE /roles/:role_id/permissions/:id(.:format)                                      {:action=>"destroy", :controller=>"subdomains/permissions"}
#                                   roles GET    /roles(.:format)                                                               {:action=>"index", :controller=>"subdomains/roles"}
#                                         POST   /roles(.:format)                                                               {:action=>"create", :controller=>"subdomains/roles"}
#                                new_role GET    /roles/new(.:format)                                                           {:action=>"new", :controller=>"subdomains/roles"}
#                               edit_role GET    /roles/:id/edit(.:format)                                                      {:action=>"edit", :controller=>"subdomains/roles"}
#                                    role GET    /roles/:id(.:format)                                                           {:action=>"show", :controller=>"subdomains/roles"}
#                                         PUT    /roles/:id(.:format)                                                           {:action=>"update", :controller=>"subdomains/roles"}
#                                         DELETE /roles/:id(.:format)                                                           {:action=>"destroy", :controller=>"subdomains/roles"}
#              pending_roster_assignments GET    /roster_assignments/pending(.:format)                                          {:controller=>"subdomains/roster_assignments", :action=>"pending"}
#                   my_roster_assignments GET    /my_roster_assignments(.:format)                                               {:controller=>"subdomains/roster_assignments", :action=>"mine"}
#        batch_approve_roster_assignments PUT    /roster_assignments/batch_approve(.:format)                                    {:controller=>"subdomains/roster_assignments", :action=>"batch_approve"}
#         batch_reject_roster_assignments PUT    /roster_assignments/batch_reject(.:format)                                     {:controller=>"subdomains/roster_assignments", :action=>"batch_reject"}
#        batch_destroy_roster_assignments DELETE /roster_assignments/batch_remove(.:format)                                     {:controller=>"subdomains/roster_assignments", :action=>"batch_destroy"}
#               approve_roster_assignment PUT    /roster_assignments/:id/approve(.:format)                                      {:action=>"approve", :controller=>"subdomains/roster_assignments"}
#                reject_roster_assignment PUT    /roster_assignments/:id/reject(.:format)                                       {:action=>"reject", :controller=>"subdomains/roster_assignments"}
#                      roster_assignments GET    /roster_assignments(.:format)                                                  {:action=>"index", :controller=>"subdomains/roster_assignments"}
#                                         POST   /roster_assignments(.:format)                                                  {:action=>"create", :controller=>"subdomains/roster_assignments"}
#                  edit_roster_assignment GET    /roster_assignments/:id/edit(.:format)                                         {:action=>"edit", :controller=>"subdomains/roster_assignments"}
#                       roster_assignment PUT    /roster_assignments/:id(.:format)                                              {:action=>"update", :controller=>"subdomains/roster_assignments"}
#                                         DELETE /roster_assignments/:id(.:format)                                              {:action=>"destroy", :controller=>"subdomains/roster_assignments"}
#            accept_community_application POST   /community_applications/:id/accept(.:format)                                   {:action=>"accept", :controller=>"subdomains/community_applications"}
#            reject_community_application POST   /community_applications/:id/reject(.:format)                                   {:action=>"reject", :controller=>"subdomains/community_applications"}
#                  community_applications GET    /community_applications(.:format)                                              {:action=>"index", :controller=>"subdomains/community_applications"}
#                                         POST   /community_applications(.:format)                                              {:action=>"create", :controller=>"subdomains/community_applications"}
#               new_community_application GET    /community_applications/new(.:format)                                          {:action=>"new", :controller=>"subdomains/community_applications"}
#                   community_application GET    /community_applications/:id(.:format)                                          {:action=>"show", :controller=>"subdomains/community_applications"}
#                                         DELETE /community_applications/:id(.:format)                                          {:action=>"destroy", :controller=>"subdomains/community_applications"}
#                   custom_form_questions GET    /custom_forms/:custom_form_id/questions(.:format)                              {:action=>"index", :controller=>"subdomains/questions"}
#                                         POST   /custom_forms/:custom_form_id/questions(.:format)                              {:action=>"create", :controller=>"subdomains/questions"}
#                new_custom_form_question GET    /custom_forms/:custom_form_id/questions/new(.:format)                          {:action=>"new", :controller=>"subdomains/questions"}
#                           edit_question GET    /questions/:id/edit(.:format)                                                  {:action=>"edit", :controller=>"subdomains/questions"}
#                                question GET    /questions/:id(.:format)                                                       {:action=>"show", :controller=>"subdomains/questions"}
#                                         PUT    /questions/:id(.:format)                                                       {:action=>"update", :controller=>"subdomains/questions"}
#                                         DELETE /questions/:id(.:format)                                                       {:action=>"destroy", :controller=>"subdomains/questions"}
#                 custom_form_submissions GET    /custom_forms/:custom_form_id/submissions(.:format)                            {:action=>"index", :controller=>"subdomains/submissions"}
#                              submission DELETE /submissions/:id(.:format)                                                     {:action=>"destroy", :controller=>"subdomains/submissions"}
#          custom_form_submission_answers GET    /custom_forms/:custom_form_id/submissions/:submission_id/answers(.:format)     {:action=>"index", :controller=>"subdomains/answers"}
#                                         POST   /custom_forms/:custom_form_id/submissions/:submission_id/answers(.:format)     {:action=>"create", :controller=>"subdomains/answers"}
#       new_custom_form_submission_answer GET    /custom_forms/:custom_form_id/submissions/:submission_id/answers/new(.:format) {:action=>"new", :controller=>"subdomains/answers"}
#           custom_form_submission_answer GET    /custom_forms/:custom_form_id/submissions/:submission_id/answers/:id(.:format) {:action=>"show", :controller=>"subdomains/answers"}
#                                         GET    /custom_forms/:custom_form_id/submissions(.:format)                            {:action=>"index", :controller=>"subdomains/submissions"}
#                                         POST   /custom_forms/:custom_form_id/submissions(.:format)                            {:action=>"create", :controller=>"subdomains/submissions"}
#              new_custom_form_submission GET    /custom_forms/:custom_form_id/submissions/new(.:format)                        {:action=>"new", :controller=>"subdomains/submissions"}
#                  custom_form_submission GET    /custom_forms/:custom_form_id/submissions/:id(.:format)                        {:action=>"show", :controller=>"subdomains/submissions"}
#                            custom_forms GET    /custom_forms(.:format)                                                        {:action=>"index", :controller=>"subdomains/custom_forms"}
#                                         POST   /custom_forms(.:format)                                                        {:action=>"create", :controller=>"subdomains/custom_forms"}
#                         new_custom_form GET    /custom_forms/new(.:format)                                                    {:action=>"new", :controller=>"subdomains/custom_forms"}
#                        edit_custom_form GET    /custom_forms/:id/edit(.:format)                                               {:action=>"edit", :controller=>"subdomains/custom_forms"}
#                             custom_form PUT    /custom_forms/:id(.:format)                                                    {:action=>"update", :controller=>"subdomains/custom_forms"}
#                                         DELETE /custom_forms/:id(.:format)                                                    {:action=>"destroy", :controller=>"subdomains/custom_forms"}
#                            lock_comment POST   /comments/:id/lock(.:format)                                                   {:action=>"lock", :controller=>"subdomains/comments"}
#                          unlock_comment POST   /comments/:id/unlock(.:format)                                                 {:action=>"unlock", :controller=>"subdomains/comments"}
#                                comments POST   /comments(.:format)                                                            {:action=>"create", :controller=>"subdomains/comments"}
#                             new_comment GET    /comments/new(.:format)                                                        {:action=>"new", :controller=>"subdomains/comments"}
#                            edit_comment GET    /comments/:id/edit(.:format)                                                   {:action=>"edit", :controller=>"subdomains/comments"}
#                                 comment PUT    /comments/:id(.:format)                                                        {:action=>"update", :controller=>"subdomains/comments"}
#                                         DELETE /comments/:id(.:format)                                                        {:action=>"destroy", :controller=>"subdomains/comments"}
#                         lock_discussion POST   /discussions/:id/lock(.:format)                                                {:action=>"lock", :controller=>"subdomains/discussions"}
#                       unlock_discussion POST   /discussions/:id/unlock(.:format)                                              {:action=>"unlock", :controller=>"subdomains/discussions"}
#            discussion_space_discussions POST   /discussion_spaces/:discussion_space_id/discussions(.:format)                  {:action=>"create", :controller=>"subdomains/discussions"}
#         new_discussion_space_discussion GET    /discussion_spaces/:discussion_space_id/discussions/new(.:format)              {:action=>"new", :controller=>"subdomains/discussions"}
#                         edit_discussion GET    /discussions/:id/edit(.:format)                                                {:action=>"edit", :controller=>"subdomains/discussions"}
#                              discussion GET    /discussions/:id(.:format)                                                     {:action=>"show", :controller=>"subdomains/discussions"}
#                                         PUT    /discussions/:id(.:format)                                                     {:action=>"update", :controller=>"subdomains/discussions"}
#                                         DELETE /discussions/:id(.:format)                                                     {:action=>"destroy", :controller=>"subdomains/discussions"}
#                       discussion_spaces GET    /discussion_spaces(.:format)                                                   {:action=>"index", :controller=>"subdomains/discussion_spaces"}
#                                         POST   /discussion_spaces(.:format)                                                   {:action=>"create", :controller=>"subdomains/discussion_spaces"}
#                    new_discussion_space GET    /discussion_spaces/new(.:format)                                               {:action=>"new", :controller=>"subdomains/discussion_spaces"}
#                   edit_discussion_space GET    /discussion_spaces/:id/edit(.:format)                                          {:action=>"edit", :controller=>"subdomains/discussion_spaces"}
#                        discussion_space GET    /discussion_spaces/:id(.:format)                                               {:action=>"show", :controller=>"subdomains/discussion_spaces"}
#                                         PUT    /discussion_spaces/:id(.:format)                                               {:action=>"update", :controller=>"subdomains/discussion_spaces"}
#                                         DELETE /discussion_spaces/:id(.:format)                                               {:action=>"destroy", :controller=>"subdomains/discussion_spaces"}
#                       lock_announcement POST   /announcements/:id/lock(.:format)                                              {:action=>"lock", :controller=>"subdomains/announcements"}
#                     unlock_announcement POST   /announcements/:id/unlock(.:format)                                            {:action=>"unlock", :controller=>"subdomains/announcements"}
#        announcement_space_announcements POST   /announcement_spaces/:announcement_space_id/announcements(.:format)            {:action=>"create", :controller=>"subdomains/announcements"}
#     new_announcement_space_announcement GET    /announcement_spaces/:announcement_space_id/announcements/new(.:format)        {:action=>"new", :controller=>"subdomains/announcements"}
#                       edit_announcement GET    /announcements/:id/edit(.:format)                                              {:action=>"edit", :controller=>"subdomains/announcements"}
#                            announcement GET    /announcements/:id(.:format)                                                   {:action=>"show", :controller=>"subdomains/announcements"}
#                                         PUT    /announcements/:id(.:format)                                                   {:action=>"update", :controller=>"subdomains/announcements"}
#                                         DELETE /announcements/:id(.:format)                                                   {:action=>"destroy", :controller=>"subdomains/announcements"}
#                     announcement_spaces GET    /announcement_spaces(.:format)                                                 {:action=>"index", :controller=>"subdomains/announcement_spaces"}
#                      announcement_space GET    /announcement_spaces/:id(.:format)                                             {:action=>"show", :controller=>"subdomains/announcement_spaces"}
#                        page_space_pages GET    /page_spaces/:page_space_id/pages(.:format)                                    {:action=>"index", :controller=>"subdomains/pages"}
#                                         POST   /page_spaces/:page_space_id/pages(.:format)                                    {:action=>"create", :controller=>"subdomains/pages"}
#                     new_page_space_page GET    /page_spaces/:page_space_id/pages/new(.:format)                                {:action=>"new", :controller=>"subdomains/pages"}
#                               edit_page GET    /pages/:id/edit(.:format)                                                      {:action=>"edit", :controller=>"subdomains/pages"}
#                                    page GET    /pages/:id(.:format)                                                           {:action=>"show", :controller=>"subdomains/pages"}
#                                         PUT    /pages/:id(.:format)                                                           {:action=>"update", :controller=>"subdomains/pages"}
#                                         DELETE /pages/:id(.:format)                                                           {:action=>"destroy", :controller=>"subdomains/pages"}
#                             page_spaces GET    /page_spaces(.:format)                                                         {:action=>"index", :controller=>"subdomains/page_spaces"}
#                                         POST   /page_spaces(.:format)                                                         {:action=>"create", :controller=>"subdomains/page_spaces"}
#                          new_page_space GET    /page_spaces/new(.:format)                                                     {:action=>"new", :controller=>"subdomains/page_spaces"}
#                         edit_page_space GET    /page_spaces/:id/edit(.:format)                                                {:action=>"edit", :controller=>"subdomains/page_spaces"}
#                              page_space GET    /page_spaces/:id(.:format)                                                     {:action=>"show", :controller=>"subdomains/page_spaces"}
#                                         PUT    /page_spaces/:id(.:format)                                                     {:action=>"update", :controller=>"subdomains/page_spaces"}
#                                         DELETE /page_spaces/:id(.:format)                                                     {:action=>"destroy", :controller=>"subdomains/page_spaces"}
#                         supported_games GET    /supported_games(.:format)                                                     {:action=>"index", :controller=>"subdomains/supported_games"}
#                                         POST   /supported_games(.:format)                                                     {:action=>"create", :controller=>"subdomains/supported_games"}
#                      new_supported_game GET    /supported_games/new(.:format)                                                 {:action=>"new", :controller=>"subdomains/supported_games"}
#                     edit_supported_game GET    /supported_games/:id/edit(.:format)                                            {:action=>"edit", :controller=>"subdomains/supported_games"}
#                          supported_game GET    /supported_games/:id(.:format)                                                 {:action=>"show", :controller=>"subdomains/supported_games"}
#                                         PUT    /supported_games/:id(.:format)                                                 {:action=>"update", :controller=>"subdomains/supported_games"}
#                                         DELETE /supported_games/:id(.:format)                                                 {:action=>"destroy", :controller=>"subdomains/supported_games"}
#                                    root        /                                                                              {:controller=>"crumblin", :action=>"index"}
#                          crumblin_index GET    /crumblin/index(.:format)                                                      {:controller=>"crumblin", :action=>"index"}
#                          crumblin_intro GET    /intro(.:format)                                                               {:controller=>"crumblin", :action=>"intro"}
#                       crumblin_features GET    /features(.:format)                                                            {:controller=>"crumblin", :action=>"features"}
#                        crumblin_pricing GET    /pricing(.:format)                                                             {:controller=>"crumblin", :action=>"pricing"}
#                    crumblin_maintenance GET    /maintenance(.:format)                                                         {:controller=>"crumblin", :action=>"maintenance"}
#                 crumblin_privacy_policy GET    /privacy-policy(.:format)                                                      {:controller=>"crumblin", :action=>"privacy_policy"}
#               crumblin_terms_of_service GET    /terms-of-service(.:format)                                                    {:controller=>"crumblin", :action=>"terms_of_service"}

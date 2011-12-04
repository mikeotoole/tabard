DaBvRails::Application.routes.draw do
  # Admin Users
  ActiveAdmin.routes(self)
  devise_for :admin_users do match "/admin/login" => "admin/devise/sessions#new" end
  devise_for :admin_users , ActiveAdmin::Devise.config

  # Users
  devise_for :users, :controllers => {  :sessions => 'sessions', :registrations => 'registrations' }
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
  resources :communities, :except => [:destroy, :create]

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

      # Roles and Permissions
      resources :roles do
        resources :permissions
      end

      # Roster assignments
      get '/roster_assignments/pending' => 'roster_assignments#pending', :as => "pending_roster_assignments"
      resources :roster_assignments do
        member do
          put :approve
          put :reject
        end
      end

      # Community applications
      resources :community_applications do
        member do
          post :accept
          post :reject
        end
      end

      # Custom Forms
      resources :custom_forms do
        resources :questions, :shallow => true
        resources :submissions, :shallow => true, :except => [:update, :edit] do
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

  # Crumblin Home page
  root :to => 'crumblin#index'
  get "crumblin/index"

  # Crumblin top level pages
  get "/intro" => "crumblin#intro", :as => 'crumblin_intro'
  get "/features" => "crumblin#features", :as => 'crumblin_features'
  get "/pricing" => "crumblin#pricing", :as => 'crumblin_pricing'
  get "/maintenance" => "crumblin#maintenance", :as => 'crumblin_maintenance'
  get "/privacy-policy" => "crumblin#privacy_policy", :as => 'crumblin_privacy_policy'
  get "/terms-of-service" => "crumblin#terms_of_service", :as => 'crumblin_terms_of_service'

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
# Generated on 01 Nov 2011 23:30
#
#           accept_document_create POST   /accept_document/:id(.:format)                                    {:controller=>"document_acceptance", :action=>"create"}
#                        documents GET    /documents(.:format)                                              {:action=>"index", :controller=>"documents"}
#                                  POST   /documents(.:format)                                              {:action=>"create", :controller=>"documents"}
#                     new_document GET    /documents/new(.:format)                                          {:action=>"new", :controller=>"documents"}
#                    edit_document GET    /documents/:id/edit(.:format)                                     {:action=>"edit", :controller=>"documents"}
#                         document GET    /documents/:id(.:format)                                          {:action=>"show", :controller=>"documents"}
#                                  PUT    /documents/:id(.:format)                                          {:action=>"update", :controller=>"documents"}
#                                  DELETE /documents/:id(.:format)                                          {:action=>"destroy", :controller=>"documents"}
#                 new_user_session GET    /users/sign_in(.:format)                                          {:action=>"new", :controller=>"devise/sessions"}
#                     user_session POST   /users/sign_in(.:format)                                          {:action=>"create", :controller=>"devise/sessions"}
#             destroy_user_session GET    /users/sign_out(.:format)                                         {:action=>"destroy", :controller=>"devise/sessions"}
#                    user_password POST   /users/password(.:format)                                         {:action=>"create", :controller=>"devise/passwords"}
#                new_user_password GET    /users/password/new(.:format)                                     {:action=>"new", :controller=>"devise/passwords"}
#               edit_user_password GET    /users/password/edit(.:format)                                    {:action=>"edit", :controller=>"devise/passwords"}
#                                  PUT    /users/password(.:format)                                         {:action=>"update", :controller=>"devise/passwords"}
#         cancel_user_registration GET    /users/cancel(.:format)                                           {:action=>"cancel", :controller=>"devise/registrations"}
#                user_registration POST   /users(.:format)                                                  {:action=>"create", :controller=>"devise/registrations"}
#            new_user_registration GET    /users/sign_up(.:format)                                          {:action=>"new", :controller=>"devise/registrations"}
#           edit_user_registration GET    /users/edit(.:format)                                             {:action=>"edit", :controller=>"devise/registrations"}
#                                  PUT    /users(.:format)                                                  {:action=>"update", :controller=>"devise/registrations"}
#                                  DELETE /users(.:format)                                                  {:action=>"destroy", :controller=>"devise/registrations"}
#                user_confirmation POST   /users/confirmation(.:format)                                     {:action=>"create", :controller=>"devise/confirmations"}
#            new_user_confirmation GET    /users/confirmation/new(.:format)                                 {:action=>"new", :controller=>"devise/confirmations"}
#                                  GET    /users/confirmation(.:format)                                     {:action=>"show", :controller=>"devise/confirmations"}
#                      user_unlock POST   /users/unlock(.:format)                                           {:action=>"create", :controller=>"devise/unlocks"}
#                  new_user_unlock GET    /users/unlock/new(.:format)                                       {:action=>"new", :controller=>"devise/unlocks"}
#                                  GET    /users/unlock(.:format)                                           {:action=>"show", :controller=>"devise/unlocks"}
#                        user_root        /dashboard(.:format)                                              {:controller=>"user_profiles", :action=>"index"}
#                    user_profiles GET    /user_profiles(.:format)                                          {:action=>"index", :controller=>"user_profiles"}
#                edit_user_profile GET    /user_profiles/:id/edit(.:format)                                 {:action=>"edit", :controller=>"user_profiles"}
#                     user_profile GET    /user_profiles/:id(.:format)                                      {:action=>"show", :controller=>"user_profiles"}
#                                  PUT    /user_profiles/:id(.:format)                                      {:action=>"update", :controller=>"user_profiles"}
#                          account GET    /account(.:format)                                                {:controller=>"user_profiles", :action=>"account"}
#                   update_account PUT    /account/update(.:format)                                         {:controller=>"user_profiles", :action=>"update"}
#                  active_profiles POST   /active_profiles(.:format)                                        {:action=>"create", :controller=>"active_profiles"}
#                   active_profile POST   /active_profile/:id/:type(.:format)                               {:controller=>"active_profiles", :action=>"create"}
#                      communities GET    /communities(.:format)                                            {:action=>"index", :controller=>"communities"}
#                                  POST   /communities(.:format)                                            {:action=>"create", :controller=>"communities"}
#                    new_community GET    /communities/new(.:format)                                        {:action=>"new", :controller=>"communities"}
#                   edit_community GET    /communities/:id/edit(.:format)                                   {:action=>"edit", :controller=>"communities"}
#                        community GET    /communities/:id(.:format)                                        {:action=>"show", :controller=>"communities"}
#                                  PUT    /communities/:id(.:format)                                        {:action=>"update", :controller=>"communities"}
#                             game GET    /games/:id(.:format)                                              {:action=>"show", :controller=>"games"}
#                new_wow_character GET    /wow_characters/new(.:format)                                     {:controller=>"base_characters", :action=>"new"}
#              new_swtor_character GET    /swtor_characters/new(.:format)                                   {:controller=>"base_characters", :action=>"new"}
#                   wow_characters POST   /wow_characters(.:format)                                         {:action=>"create", :controller=>"wow_characters"}
#               edit_wow_character GET    /wow_characters/:id/edit(.:format)                                {:action=>"edit", :controller=>"wow_characters"}
#                    wow_character GET    /wow_characters/:id(.:format)                                     {:action=>"show", :controller=>"wow_characters"}
#                                  PUT    /wow_characters/:id(.:format)                                     {:action=>"update", :controller=>"wow_characters"}
#                                  DELETE /wow_characters/:id(.:format)                                     {:action=>"destroy", :controller=>"wow_characters"}
#                 swtor_characters POST   /swtor_characters(.:format)                                       {:action=>"create", :controller=>"swtor_characters"}
#             edit_swtor_character GET    /swtor_characters/:id/edit(.:format)                              {:action=>"edit", :controller=>"swtor_characters"}
#                  swtor_character GET    /swtor_characters/:id(.:format)                                   {:action=>"show", :controller=>"swtor_characters"}
#                                  PUT    /swtor_characters/:id(.:format)                                   {:action=>"update", :controller=>"swtor_characters"}
#                                  DELETE /swtor_characters/:id(.:format)                                   {:action=>"destroy", :controller=>"swtor_characters"}
#               new_base_character GET    /base_characters/new(.:format)                                    {:action=>"new", :controller=>"base_characters"}
#                    sent_messages POST   /sent_messages(.:format)                                          {:action=>"create", :controller=>"sent_messages"}
#                        sent_mail GET    /mail/sent/:id(.:format)                                          {:controller=>"sent_messages", :action=>"show"}
#                     sent_mailbox GET    /mail/sent(.:format)                                              {:controller=>"sent_messages", :action=>"index"}
#                     compose_mail GET    /mail/compose(.:format)                                           {:controller=>"sent_messages", :action=>"new"}
#                  compose_mail_to GET    /mail/compose/:id(.:format)                                       {:controller=>"sent_messages", :action=>"new"}
#                             mail GET    /mail/inbox/:id(.:format)                                         {:controller=>"messages", :action=>"show"}
#                   mail_mark_read POST   /mail/mark_read/:id(.:format)                                     {:controller=>"messages", :action=>"mark_read"}
#                 mail_mark_unread POST   /mail/mark_unread/:id(.:format)                                   {:controller=>"messages", :action=>"mark_unread"}
#                        mail_move PUT    /mail/:id/move/:folder_id(.:format)                               {:controller=>"messages", :action=>"move"}
#                  mail_batch_move PUT    /mail/batch_move/:folder_id(.:format)                             {:controller=>"messages", :action=>"batch_move"}
#             mail_batch_mark_read PUT    /mail/batch_mark_read(.:format)                                   {:controller=>"messages", :action=>"batch_mark_read"}
#           mail_batch_mark_unread PUT    /mail/batch_mark_unread(.:format)                                 {:controller=>"messages", :action=>"batch_mark_unread"}
#                       mail_reply GET    /mail/reply/:id(.:format)                                         {:controller=>"messages", :action=>"reply"}
#                   mail_reply_all GET    /mail/reply-all/:id(.:format)                                     {:controller=>"messages", :action=>"reply_all"}
#                     mail_forward GET    /mail/forward/:id(.:format)                                       {:controller=>"messages", :action=>"forward"}
#                      mail_delete DELETE /mail/delete/:id(.:format)                                        {:controller=>"messages", :action=>"destroy"}
#                  mail_delete_all DELETE /mail/delete(.:format)                                            {:controller=>"messages", :action=>"destroy"}
#                mail_batch_delete DELETE /mail/batch_delete(.:format)                                      {:controller=>"messages", :action=>"batch_destroy"}
#                            inbox GET    /mail/inbox(.:format)                                             {:controller=>"mailbox", :action=>"inbox"}
#                            trash GET    /mail/trash(.:format)                                             {:controller=>"mailbox", :action=>"trash"}
#                    announcements GET    /announcements(.:format)                                          {:action=>"index", :controller=>"announcements"}
# announcements_batch_mark_as_seen PUT    /announcements/batch_mark_as_seen(.:format)                       {:controller=>"announcements", :action=>"batch_mark_as_seen"}
#                   subdomain_home GET    /                                                                 {:controller=>"subdomains", :action=>"index"}
#                 role_permissions GET    /roles/:role_id/permissions(.:format)                             {:action=>"index", :controller=>"subdomains/permissions"}
#                                  POST   /roles/:role_id/permissions(.:format)                             {:action=>"create", :controller=>"subdomains/permissions"}
#              new_role_permission GET    /roles/:role_id/permissions/new(.:format)                         {:action=>"new", :controller=>"subdomains/permissions"}
#             edit_role_permission GET    /roles/:role_id/permissions/:id/edit(.:format)                    {:action=>"edit", :controller=>"subdomains/permissions"}
#                  role_permission GET    /roles/:role_id/permissions/:id(.:format)                         {:action=>"show", :controller=>"subdomains/permissions"}
#                                  PUT    /roles/:role_id/permissions/:id(.:format)                         {:action=>"update", :controller=>"subdomains/permissions"}
#                                  DELETE /roles/:role_id/permissions/:id(.:format)                         {:action=>"destroy", :controller=>"subdomains/permissions"}
#                            roles GET    /roles(.:format)                                                  {:action=>"index", :controller=>"subdomains/roles"}
#                                  POST   /roles(.:format)                                                  {:action=>"create", :controller=>"subdomains/roles"}
#                         new_role GET    /roles/new(.:format)                                              {:action=>"new", :controller=>"subdomains/roles"}
#                        edit_role GET    /roles/:id/edit(.:format)                                         {:action=>"edit", :controller=>"subdomains/roles"}
#                             role GET    /roles/:id(.:format)                                              {:action=>"show", :controller=>"subdomains/roles"}
#                                  PUT    /roles/:id(.:format)                                              {:action=>"update", :controller=>"subdomains/roles"}
#                                  DELETE /roles/:id(.:format)                                              {:action=>"destroy", :controller=>"subdomains/roles"}
#       pending_roster_assignments GET    /roster_assignments/pending(.:format)                             {:controller=>"subdomains/roster_assignments", :action=>"pending"}
#        approve_roster_assignment PUT    /roster_assignments/:id/approve(.:format)                         {:action=>"approve", :controller=>"subdomains/roster_assignments"}
#         reject_roster_assignment PUT    /roster_assignments/:id/reject(.:format)                          {:action=>"reject", :controller=>"subdomains/roster_assignments"}
#               roster_assignments GET    /roster_assignments(.:format)                                     {:action=>"index", :controller=>"subdomains/roster_assignments"}
#                                  POST   /roster_assignments(.:format)                                     {:action=>"create", :controller=>"subdomains/roster_assignments"}
#            new_roster_assignment GET    /roster_assignments/new(.:format)                                 {:action=>"new", :controller=>"subdomains/roster_assignments"}
#           edit_roster_assignment GET    /roster_assignments/:id/edit(.:format)                            {:action=>"edit", :controller=>"subdomains/roster_assignments"}
#                roster_assignment GET    /roster_assignments/:id(.:format)                                 {:action=>"show", :controller=>"subdomains/roster_assignments"}
#                                  PUT    /roster_assignments/:id(.:format)                                 {:action=>"update", :controller=>"subdomains/roster_assignments"}
#                                  DELETE /roster_assignments/:id(.:format)                                 {:action=>"destroy", :controller=>"subdomains/roster_assignments"}
#     accept_community_application POST   /community_applications/:id/accept(.:format)                      {:action=>"accept", :controller=>"subdomains/community_applications"}
#     reject_community_application POST   /community_applications/:id/reject(.:format)                      {:action=>"reject", :controller=>"subdomains/community_applications"}
#           community_applications GET    /community_applications(.:format)                                 {:action=>"index", :controller=>"subdomains/community_applications"}
#                                  POST   /community_applications(.:format)                                 {:action=>"create", :controller=>"subdomains/community_applications"}
#        new_community_application GET    /community_applications/new(.:format)                             {:action=>"new", :controller=>"subdomains/community_applications"}
#       edit_community_application GET    /community_applications/:id/edit(.:format)                        {:action=>"edit", :controller=>"subdomains/community_applications"}
#            community_application GET    /community_applications/:id(.:format)                             {:action=>"show", :controller=>"subdomains/community_applications"}
#                                  PUT    /community_applications/:id(.:format)                             {:action=>"update", :controller=>"subdomains/community_applications"}
#                                  DELETE /community_applications/:id(.:format)                             {:action=>"destroy", :controller=>"subdomains/community_applications"}
#            custom_form_questions GET    /custom_forms/:custom_form_id/questions(.:format)                 {:action=>"index", :controller=>"subdomains/questions"}
#                                  POST   /custom_forms/:custom_form_id/questions(.:format)                 {:action=>"create", :controller=>"subdomains/questions"}
#         new_custom_form_question GET    /custom_forms/:custom_form_id/questions/new(.:format)             {:action=>"new", :controller=>"subdomains/questions"}
#                    edit_question GET    /questions/:id/edit(.:format)                                     {:action=>"edit", :controller=>"subdomains/questions"}
#                         question GET    /questions/:id(.:format)                                          {:action=>"show", :controller=>"subdomains/questions"}
#                                  PUT    /questions/:id(.:format)                                          {:action=>"update", :controller=>"subdomains/questions"}
#                                  DELETE /questions/:id(.:format)                                          {:action=>"destroy", :controller=>"subdomains/questions"}
#               submission_answers GET    /submissions/:submission_id/answers(.:format)                     {:action=>"index", :controller=>"subdomains/answers"}
#                                  POST   /submissions/:submission_id/answers(.:format)                     {:action=>"create", :controller=>"subdomains/answers"}
#            new_submission_answer GET    /submissions/:submission_id/answers/new(.:format)                 {:action=>"new", :controller=>"subdomains/answers"}
#                           answer GET    /answers/:id(.:format)                                            {:action=>"show", :controller=>"subdomains/answers"}
#          custom_form_submissions GET    /custom_forms/:custom_form_id/submissions(.:format)               {:action=>"index", :controller=>"subdomains/submissions"}
#                                  POST   /custom_forms/:custom_form_id/submissions(.:format)               {:action=>"create", :controller=>"subdomains/submissions"}
#       new_custom_form_submission GET    /custom_forms/:custom_form_id/submissions/new(.:format)           {:action=>"new", :controller=>"subdomains/submissions"}
#                       submission GET    /submissions/:id(.:format)                                        {:action=>"show", :controller=>"subdomains/submissions"}
#                                  DELETE /submissions/:id(.:format)                                        {:action=>"destroy", :controller=>"subdomains/submissions"}
#                     custom_forms GET    /custom_forms(.:format)                                           {:action=>"index", :controller=>"subdomains/custom_forms"}
#                                  POST   /custom_forms(.:format)                                           {:action=>"create", :controller=>"subdomains/custom_forms"}
#                  new_custom_form GET    /custom_forms/new(.:format)                                       {:action=>"new", :controller=>"subdomains/custom_forms"}
#                 edit_custom_form GET    /custom_forms/:id/edit(.:format)                                  {:action=>"edit", :controller=>"subdomains/custom_forms"}
#                      custom_form GET    /custom_forms/:id(.:format)                                       {:action=>"show", :controller=>"subdomains/custom_forms"}
#                                  PUT    /custom_forms/:id(.:format)                                       {:action=>"update", :controller=>"subdomains/custom_forms"}
#                                  DELETE /custom_forms/:id(.:format)                                       {:action=>"destroy", :controller=>"subdomains/custom_forms"}
#                     lock_comment POST   /comments/:id/lock(.:format)                                      {:action=>"lock", :controller=>"subdomains/comments"}
#                   unlock_comment POST   /comments/:id/unlock(.:format)                                    {:action=>"unlock", :controller=>"subdomains/comments"}
#                         comments POST   /comments(.:format)                                               {:action=>"create", :controller=>"subdomains/comments"}
#                      new_comment GET    /comments/new(.:format)                                           {:action=>"new", :controller=>"subdomains/comments"}
#                     edit_comment GET    /comments/:id/edit(.:format)                                      {:action=>"edit", :controller=>"subdomains/comments"}
#                          comment PUT    /comments/:id(.:format)                                           {:action=>"update", :controller=>"subdomains/comments"}
#                                  DELETE /comments/:id(.:format)                                           {:action=>"destroy", :controller=>"subdomains/comments"}
#                  lock_discussion POST   /discussions/:id/lock(.:format)                                   {:action=>"lock", :controller=>"subdomains/discussions"}
#                unlock_discussion POST   /discussions/:id/unlock(.:format)                                 {:action=>"unlock", :controller=>"subdomains/discussions"}
#     discussion_space_discussions GET    /discussion_spaces/:discussion_space_id/discussions(.:format)     {:action=>"index", :controller=>"subdomains/discussions"}
#                                  POST   /discussion_spaces/:discussion_space_id/discussions(.:format)     {:action=>"create", :controller=>"subdomains/discussions"}
#  new_discussion_space_discussion GET    /discussion_spaces/:discussion_space_id/discussions/new(.:format) {:action=>"new", :controller=>"subdomains/discussions"}
#                  edit_discussion GET    /discussions/:id/edit(.:format)                                   {:action=>"edit", :controller=>"subdomains/discussions"}
#                       discussion GET    /discussions/:id(.:format)                                        {:action=>"show", :controller=>"subdomains/discussions"}
#                                  PUT    /discussions/:id(.:format)                                        {:action=>"update", :controller=>"subdomains/discussions"}
#                                  DELETE /discussions/:id(.:format)                                        {:action=>"destroy", :controller=>"subdomains/discussions"}
#                discussion_spaces GET    /discussion_spaces(.:format)                                      {:action=>"index", :controller=>"subdomains/discussion_spaces"}
#                                  POST   /discussion_spaces(.:format)                                      {:action=>"create", :controller=>"subdomains/discussion_spaces"}
#             new_discussion_space GET    /discussion_spaces/new(.:format)                                  {:action=>"new", :controller=>"subdomains/discussion_spaces"}
#            edit_discussion_space GET    /discussion_spaces/:id/edit(.:format)                             {:action=>"edit", :controller=>"subdomains/discussion_spaces"}
#                 discussion_space GET    /discussion_spaces/:id(.:format)                                  {:action=>"show", :controller=>"subdomains/discussion_spaces"}
#                                  PUT    /discussion_spaces/:id(.:format)                                  {:action=>"update", :controller=>"subdomains/discussion_spaces"}
#                                  DELETE /discussion_spaces/:id(.:format)                                  {:action=>"destroy", :controller=>"subdomains/discussion_spaces"}
#                 page_space_pages GET    /page_spaces/:page_space_id/pages(.:format)                       {:action=>"index", :controller=>"subdomains/pages"}
#                                  POST   /page_spaces/:page_space_id/pages(.:format)                       {:action=>"create", :controller=>"subdomains/pages"}
#              new_page_space_page GET    /page_spaces/:page_space_id/pages/new(.:format)                   {:action=>"new", :controller=>"subdomains/pages"}
#                        edit_page GET    /pages/:id/edit(.:format)                                         {:action=>"edit", :controller=>"subdomains/pages"}
#                             page GET    /pages/:id(.:format)                                              {:action=>"show", :controller=>"subdomains/pages"}
#                                  PUT    /pages/:id(.:format)                                              {:action=>"update", :controller=>"subdomains/pages"}
#                                  DELETE /pages/:id(.:format)                                              {:action=>"destroy", :controller=>"subdomains/pages"}
#                      page_spaces GET    /page_spaces(.:format)                                            {:action=>"index", :controller=>"subdomains/page_spaces"}
#                                  POST   /page_spaces(.:format)                                            {:action=>"create", :controller=>"subdomains/page_spaces"}
#                   new_page_space GET    /page_spaces/new(.:format)                                        {:action=>"new", :controller=>"subdomains/page_spaces"}
#                  edit_page_space GET    /page_spaces/:id/edit(.:format)                                   {:action=>"edit", :controller=>"subdomains/page_spaces"}
#                       page_space GET    /page_spaces/:id(.:format)                                        {:action=>"show", :controller=>"subdomains/page_spaces"}
#                                  PUT    /page_spaces/:id(.:format)                                        {:action=>"update", :controller=>"subdomains/page_spaces"}
#                                  DELETE /page_spaces/:id(.:format)                                        {:action=>"destroy", :controller=>"subdomains/page_spaces"}
#                             root        /                                                                 {:controller=>"crumblin", :action=>"index"}
#                   crumblin_index GET    /crumblin/index(.:format)                                         {:controller=>"crumblin", :action=>"index"}
#                   crumblin_intro GET    /intro(.:format)                                                  {:controller=>"crumblin", :action=>"intro"}
#                crumblin_features GET    /features(.:format)                                               {:controller=>"crumblin", :action=>"features"}
#                 crumblin_pricing GET    /pricing(.:format)                                                {:controller=>"crumblin", :action=>"pricing"}

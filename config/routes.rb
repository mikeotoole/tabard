DaBvRails::Application.routes.draw do
  # Users
  devise_for :users
  match '/dashboard' => 'user_profiles#index', :as => 'user_root'

  # User Profiles
  resources :user_profiles, :only => [:show, :edit, :update, :index, :account]
  get "/account" => "user_profiles#account", :as => "account"
  match "/account/update" => "user_profiles#update", :as => "update_account", :via => :put

  # Active profile
  resource :active_profiles, :only => [:create]
  post 'active_profile/:id/:type' => 'active_profiles#create', :as => :active_profile

  # Communities
  resources :communities, :except => :destroy

  # Games
  resources :games, :only => :show

  # Characters
  get "/wow_characters/new" => "base_characters#new", :as => "new_wow_character"
  get "/swtor_characters/new" => "base_characters#new", :as => "new_swtor_character"
  resources :wow_characters, :except => [:index, :new]
  resources :swtor_characters, :except => [:index, :new]
  resources :base_characters, :only => :new

  # Messaging
  resources :sent_messages, :only => [:create]
  get 'mail/sent/:id' => "sent_messages#show", :as => "sent_mail"
  get 'mail/sent' => "sent_messages#index", :as => "sent_mailbox"
  get 'mail/compose' => "sent_messages#new", :as => "compose_mail"

  get 'mail/inbox/:id' => "messages#show", :as => "mail"
  post 'mail/mark_read/:id' => "messages#mark_read", :as => "mail_mark_read"
  post 'mail/mark_unread/:id' => "messages#mark_unread", :as => "mail_mark_unread"
  put 'mail/:id/move/:folder_id' => "messages#move", :as => "mail_move"
  put 'mail/batch_move/:folder_id' => "messages#batch_move", :as => "mail_batch_move"
  get 'mail/reply/:id' => "messages#reply", :as => "mail_reply"
  get 'mail/reply-all/:id' => "messages#reply_all", :as => "mail_reply_all"
  get 'mail/forward/:id' => "messages#forward", :as => "mail_forward"
  delete 'mail/delete/:id' => "messages#destroy", :as => "mail_delete"
  delete 'mail/delete' => "messages#destroy", :as => "mail_delete_all"
  delete 'mail/batch_delete' => "messages#batch_destroy", :as => "mail_batch_delete"

  get 'mail/inbox' => "mailbox#inbox", :as => "inbox"
  get 'mail/trash' => "mailbox#trash", :as => "trash"

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
        resources :discussions, :shallow => true do
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
    end
  end

  # Crumblin Home page
  root :to => 'crumblin#index'
  get "crumblin/index"

  # Crumblin top level pages
  get "/intro" => "crumblin#intro", :as => 'crumblin_intro'
  get "/features" => "crumblin#features", :as => 'crumblin_features'
  get "/pricing" => "crumblin#pricing", :as => 'crumblin_pricing'

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
# Generated on 17 Sep 2011 17:26
#
#                    user_session POST   /users/sign_in(.:format)                                          {:action=>"create", :controller=>"devise/sessions"}
#            destroy_user_session DELETE /users/sign_out(.:format)                                         {:action=>"destroy", :controller=>"devise/sessions"}
#                   user_password POST   /users/password(.:format)                                         {:action=>"create", :controller=>"devise/passwords"}
#               new_user_password GET    /users/password/new(.:format)                                     {:action=>"new", :controller=>"devise/passwords"}
#              edit_user_password GET    /users/password/edit(.:format)                                    {:action=>"edit", :controller=>"devise/passwords"}
#                                 PUT    /users/password(.:format)                                         {:action=>"update", :controller=>"devise/passwords"}
#        cancel_user_registration GET    /users/cancel(.:format)                                           {:action=>"cancel", :controller=>"devise/registrations"}
#               user_registration POST   /users(.:format)                                                  {:action=>"create", :controller=>"devise/registrations"}
#           new_user_registration GET    /users/sign_up(.:format)                                          {:action=>"new", :controller=>"devise/registrations"}
#          edit_user_registration GET    /users/edit(.:format)                                             {:action=>"edit", :controller=>"devise/registrations"}
#                                 PUT    /users(.:format)                                                  {:action=>"update", :controller=>"devise/registrations"}
#                                 DELETE /users(.:format)                                                  {:action=>"destroy", :controller=>"devise/registrations"}
#               user_confirmation POST   /users/confirmation(.:format)                                     {:action=>"create", :controller=>"devise/confirmations"}
#           new_user_confirmation GET    /users/confirmation/new(.:format)                                 {:action=>"new", :controller=>"devise/confirmations"}
#                                 GET    /users/confirmation(.:format)                                     {:action=>"show", :controller=>"devise/confirmations"}
#                     user_unlock POST   /users/unlock(.:format)                                           {:action=>"create", :controller=>"devise/unlocks"}
#                 new_user_unlock GET    /users/unlock/new(.:format)                                       {:action=>"new", :controller=>"devise/unlocks"}
#                                 GET    /users/unlock(.:format)                                           {:action=>"show", :controller=>"devise/unlocks"}
#               edit_user_profile GET    /user_profiles/:id/edit(.:format)                                 {:action=>"edit", :controller=>"user_profiles"}
#                    user_profile GET    /user_profiles/:id(.:format)                                      {:action=>"show", :controller=>"user_profiles"}
#                                 PUT    /user_profiles/:id(.:format)                                      {:action=>"update", :controller=>"user_profiles"}
#                         account        /account(.:format)                                                {:controller=>"user_profile", :action=>"account"}
#                  update_account PUT    /account/update(.:format)                                         {:controller=>"user_profile", :action=>"update"}
#                     communities GET    /communities(.:format)                                            {:action=>"index", :controller=>"communities"}
#                                 POST   /communities(.:format)                                            {:action=>"create", :controller=>"communities"}
#                   new_community GET    /communities/new(.:format)                                        {:action=>"new", :controller=>"communities"}
#                  edit_community GET    /communities/:id/edit(.:format)                                   {:action=>"edit", :controller=>"communities"}
#                       community GET    /communities/:id(.:format)                                        {:action=>"show", :controller=>"communities"}
#                                 PUT    /communities/:id(.:format)                                        {:action=>"update", :controller=>"communities"}
#                            game        /game/:id(.:format)                                               {:controller=>"games", :action=>"show"}
#                                 GET    /games/:id(.:format)                                              {:action=>"show", :controller=>"games"}
#               new_wow_character        /wow_characters/new(.:format)                                     {:controller=>"base_characters", :action=>"new"}
#             new_swtor_character        /swtor_characters/new(.:format)                                   {:controller=>"base_characters", :action=>"new"}
#                  wow_characters POST   /wow_characters(.:format)                                         {:action=>"create", :controller=>"wow_characters"}
#              edit_wow_character GET    /wow_characters/:id/edit(.:format)                                {:action=>"edit", :controller=>"wow_characters"}
#                   wow_character GET    /wow_characters/:id(.:format)                                     {:action=>"show", :controller=>"wow_characters"}
#                                 PUT    /wow_characters/:id(.:format)                                     {:action=>"update", :controller=>"wow_characters"}
#                                 DELETE /wow_characters/:id(.:format)                                     {:action=>"destroy", :controller=>"wow_characters"}
#                swtor_characters POST   /swtor_characters(.:format)                                       {:action=>"create", :controller=>"swtor_characters"}
#            edit_swtor_character GET    /swtor_characters/:id/edit(.:format)                              {:action=>"edit", :controller=>"swtor_characters"}
#                 swtor_character GET    /swtor_characters/:id(.:format)                                   {:action=>"show", :controller=>"swtor_characters"}
#                                 PUT    /swtor_characters/:id(.:format)                                   {:action=>"update", :controller=>"swtor_characters"}
#                                 DELETE /swtor_characters/:id(.:format)                                   {:action=>"destroy", :controller=>"swtor_characters"}
#              new_base_character GET    /base_characters/new(.:format)                                    {:action=>"new", :controller=>"base_characters"}
#                  subdomain_home        /                                                                 {:controller=>"subdomains", :action=>"index"}
#                role_permissions GET    /roles/:role_id/permissions(.:format)                             {:action=>"index", :controller=>"subdomains/permissions"}
#                                 POST   /roles/:role_id/permissions(.:format)                             {:action=>"create", :controller=>"subdomains/permissions"}
#             new_role_permission GET    /roles/:role_id/permissions/new(.:format)                         {:action=>"new", :controller=>"subdomains/permissions"}
#            edit_role_permission GET    /roles/:role_id/permissions/:id/edit(.:format)                    {:action=>"edit", :controller=>"subdomains/permissions"}
#                 role_permission GET    /roles/:role_id/permissions/:id(.:format)                         {:action=>"show", :controller=>"subdomains/permissions"}
#                                 PUT    /roles/:role_id/permissions/:id(.:format)                         {:action=>"update", :controller=>"subdomains/permissions"}
#                                 DELETE /roles/:role_id/permissions/:id(.:format)                         {:action=>"destroy", :controller=>"subdomains/permissions"}
#                           roles GET    /roles(.:format)                                                  {:action=>"index", :controller=>"subdomains/roles"}
#                                 POST   /roles(.:format)                                                  {:action=>"create", :controller=>"subdomains/roles"}
#                        new_role GET    /roles/new(.:format)                                              {:action=>"new", :controller=>"subdomains/roles"}
#                       edit_role GET    /roles/:id/edit(.:format)                                         {:action=>"edit", :controller=>"subdomains/roles"}
#                            role GET    /roles/:id(.:format)                                              {:action=>"show", :controller=>"subdomains/roles"}
#                                 PUT    /roles/:id(.:format)                                              {:action=>"update", :controller=>"subdomains/roles"}
#                                 DELETE /roles/:id(.:format)                                              {:action=>"destroy", :controller=>"subdomains/roles"}
#           custom_form_questions GET    /custom_forms/:custom_form_id/questions(.:format)                 {:action=>"index", :controller=>"subdomains/questions"}
#                                 POST   /custom_forms/:custom_form_id/questions(.:format)                 {:action=>"create", :controller=>"subdomains/questions"}
#        new_custom_form_question GET    /custom_forms/:custom_form_id/questions/new(.:format)             {:action=>"new", :controller=>"subdomains/questions"}
#                   edit_question GET    /questions/:id/edit(.:format)                                     {:action=>"edit", :controller=>"subdomains/questions"}
#                        question GET    /questions/:id(.:format)                                          {:action=>"show", :controller=>"subdomains/questions"}
#                                 PUT    /questions/:id(.:format)                                          {:action=>"update", :controller=>"subdomains/questions"}
#                                 DELETE /questions/:id(.:format)                                          {:action=>"destroy", :controller=>"subdomains/questions"}
#              submission_answers GET    /submissions/:submission_id/answers(.:format)                     {:action=>"index", :controller=>"subdomains/answers"}
#                                 POST   /submissions/:submission_id/answers(.:format)                     {:action=>"create", :controller=>"subdomains/answers"}
#           new_submission_answer GET    /submissions/:submission_id/answers/new(.:format)                 {:action=>"new", :controller=>"subdomains/answers"}
#                          answer GET    /answers/:id(.:format)                                            {:action=>"show", :controller=>"subdomains/answers"}
#         custom_form_submissions GET    /custom_forms/:custom_form_id/submissions(.:format)               {:action=>"index", :controller=>"subdomains/submissions"}
#                                 POST   /custom_forms/:custom_form_id/submissions(.:format)               {:action=>"create", :controller=>"subdomains/submissions"}
#      new_custom_form_submission GET    /custom_forms/:custom_form_id/submissions/new(.:format)           {:action=>"new", :controller=>"subdomains/submissions"}
#                      submission GET    /submissions/:id(.:format)                                        {:action=>"show", :controller=>"subdomains/submissions"}
#                                 DELETE /submissions/:id(.:format)                                        {:action=>"destroy", :controller=>"subdomains/submissions"}
#                    custom_forms GET    /custom_forms(.:format)                                           {:action=>"index", :controller=>"subdomains/custom_forms"}
#                                 POST   /custom_forms(.:format)                                           {:action=>"create", :controller=>"subdomains/custom_forms"}
#                 new_custom_form GET    /custom_forms/new(.:format)                                       {:action=>"new", :controller=>"subdomains/custom_forms"}
#                edit_custom_form GET    /custom_forms/:id/edit(.:format)                                  {:action=>"edit", :controller=>"subdomains/custom_forms"}
#                     custom_form GET    /custom_forms/:id(.:format)                                       {:action=>"show", :controller=>"subdomains/custom_forms"}
#                                 PUT    /custom_forms/:id(.:format)                                       {:action=>"update", :controller=>"subdomains/custom_forms"}
#                                 DELETE /custom_forms/:id(.:format)                                       {:action=>"destroy", :controller=>"subdomains/custom_forms"}
#                        comments GET    /comments(.:format)                                               {:action=>"index", :controller=>"subdomains/comments"}
#                                 POST   /comments(.:format)                                               {:action=>"create", :controller=>"subdomains/comments"}
#                     new_comment GET    /comments/new(.:format)                                           {:action=>"new", :controller=>"subdomains/comments"}
#                    edit_comment GET    /comments/:id/edit(.:format)                                      {:action=>"edit", :controller=>"subdomains/comments"}
#                         comment GET    /comments/:id(.:format)                                           {:action=>"show", :controller=>"subdomains/comments"}
#                                 PUT    /comments/:id(.:format)                                           {:action=>"update", :controller=>"subdomains/comments"}
#                                 DELETE /comments/:id(.:format)                                           {:action=>"destroy", :controller=>"subdomains/comments"}
#    discussion_space_discussions GET    /discussion_spaces/:discussion_space_id/discussions(.:format)     {:action=>"index", :controller=>"subdomains/discussions"}
#                                 POST   /discussion_spaces/:discussion_space_id/discussions(.:format)     {:action=>"create", :controller=>"subdomains/discussions"}
# new_discussion_space_discussion GET    /discussion_spaces/:discussion_space_id/discussions/new(.:format) {:action=>"new", :controller=>"subdomains/discussions"}
#                 edit_discussion GET    /discussions/:id/edit(.:format)                                   {:action=>"edit", :controller=>"subdomains/discussions"}
#                      discussion GET    /discussions/:id(.:format)                                        {:action=>"show", :controller=>"subdomains/discussions"}
#                                 PUT    /discussions/:id(.:format)                                        {:action=>"update", :controller=>"subdomains/discussions"}
#                                 DELETE /discussions/:id(.:format)                                        {:action=>"destroy", :controller=>"subdomains/discussions"}
#               discussion_spaces GET    /discussion_spaces(.:format)                                      {:action=>"index", :controller=>"subdomains/discussion_spaces"}
#                                 POST   /discussion_spaces(.:format)                                      {:action=>"create", :controller=>"subdomains/discussion_spaces"}
#            new_discussion_space GET    /discussion_spaces/new(.:format)                                  {:action=>"new", :controller=>"subdomains/discussion_spaces"}
#           edit_discussion_space GET    /discussion_spaces/:id/edit(.:format)                             {:action=>"edit", :controller=>"subdomains/discussion_spaces"}
#                discussion_space GET    /discussion_spaces/:id(.:format)                                  {:action=>"show", :controller=>"subdomains/discussion_spaces"}
#                                 PUT    /discussion_spaces/:id(.:format)                                  {:action=>"update", :controller=>"subdomains/discussion_spaces"}
#                                 DELETE /discussion_spaces/:id(.:format)                                  {:action=>"destroy", :controller=>"subdomains/discussion_spaces"}
#                            root        /                                                                 {:controller=>"home", :action=>"index"}
#                      home_index GET    /home/index(.:format)                                             {:controller=>"home", :action=>"index"}

Bv::Application.routes.draw do
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
  match "/signup" => "account#new", :as => "signup", :via => :get
  match "/signup" => "account#create", :as => "signup", :via => :post
  match "/account" => "account#show", :as => "account"
  match "/account/#activity" => "account#show", :as => "account_activity"
  match "/account/#communities" => "account#show", :as => "account_communities"
  match "/account/#characters" => "account#show", :as => "account_characters"
  match "/account/#settings" => "account#show", :as => "account_settings"
  match "/account/update" => "account#update", :as => "edit_account", :via => :put
  match "/account/deactivate" => "account#destroy", :as => "deactivate_account"

  #Games
  match "/game/:id" => "games#show", :as => "game"
  resources :games, :only => :show do
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

  match 'announcement/acknowledge' => 'announcement_acknowledgement#new', :as => 'announcement_acknowledgement'

  match '/profiles/newgame' => "profiles#newgame"

  match '/login' => "sessions#new", :as => "login"
  match '/logout' => "sessions#destroy", :as => "logout"

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

  resource :session

  match 'active_profile/:id/:type' => 'active_profiles#create', :as => :active_profile

  resources :communities, :except => :show

  constraints(Subdomain) do
    match "/" => "subdomains#index"
    scope :module => "subdomains" do
      match "/search" => "search#index", :as => 'search'
      match '/management' => 'management#index', :as => 'management'
      namespace "management" do
        resources :users, :only => [:index, :destroy]

        resources :roles do
          resources :permissions, :only => [:new, :create, :update, :delete, :destroy]
        end
        resources :page_spaces,
          :discussion_spaces,
          :site_forms

        resources :registration_applications, :except => [:new, :create] do
          member do
            post :accept
            post :reject
          end
        end
      end
      resources :comments do
        member do
          post :lock
          post :unlock
        end
      end

      resources :discussion_spaces do
        resources :discussions, :controller => 'subdomains/discussion_spaces/discussions', :only => [:new, :create]
      end

      resources :discussions, :except => [:index, :new, :create] do
        member do
          post :lock
          post :unlock
        end
      end

      resources :page_spaces do
        resources :pages
      end
      resources :game_announcements
      resources :community_announcements
    end
  end

  #Announcement Helpers
  resources :announcements,
            :site_announcements
  resources :game_announcements, :controller => "announcements", :type => "GameAnnouncement", :only => :show
  resources :community_announcements, :controller => "announcements", :type => "CommunityAnnouncement", :only => :show

  root :to => "home#index"

  match "/404" => "status_code#invoke_404", :as => "status_404"
  match "*path" => "status_code#invoke_404"

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
# Generated on 23 Aug 2011 15:08
#
#                                          message DELETE /messages/:id(.:format)                                                            {:action=>"destroy", :controller=>"messages"}
#                                        sent_mail        /mail/sent/:id(.:format)                                                           {:controller=>"sent", :action=>"show"}
#                                     sent_mailbox        /mail/sent(.:format)                                                               {:controller=>"sent", :action=>"index"}
#                                     compose_mail        /mail/compose(.:format)                                                            {:controller=>"sent", :action=>"new"}
#                                       mail_reply        /mail/reply/:id(.:format)                                                          {:controller=>"messages", :action=>"reply"}
#                                   mail_reply_all        /mail/reply-all/:id(.:format)                                                      {:controller=>"messages", :action=>"reply_all"}
#                                     mail_forward        /mail/forward/:id(.:format)                                                        {:controller=>"messages", :action=>"forward"}
#                                    mail_undelete        /mail/undelete/:id(.:format)                                                       {:controller=>"messages", :action=>"undelete"}
#                                            inbox        /mail/inbox(.:format)                                                              {:controller=>"mailbox", :action=>"index"}
#                                            trash        /mail/trash(.:format)                                                              {:controller=>"mailbox", :action=>"trash"}
#                                             mail        /mail/inbox/:id(.:format)                                                          {:controller=>"messages", :action=>"show"}
#                                           signup GET    /signup(.:format)                                                                  {:controller=>"account", :action=>"new"}
#                                           signup POST   /signup(.:format)                                                                  {:controller=>"account", :action=>"create"}
#                                          account        /account(.:format)                                                                 {:controller=>"account", :action=>"show"}
#                                 account_activity        /account/#activity(.:format)                                                       {:controller=>"account", :action=>"show"}
#                              account_communities        /account/#communities(.:format)                                                    {:controller=>"account", :action=>"show"}
#                               account_characters        /account/#characters(.:format)                                                     {:controller=>"account", :action=>"show"}
#                                 account_settings        /account/#settings(.:format)                                                       {:controller=>"account", :action=>"show"}
#                                     edit_account PUT    /account/update(.:format)                                                          {:controller=>"account", :action=>"update"}
#                               deactivate_account        /account/deactivate(.:format)                                                      {:controller=>"account", :action=>"destroy"}
#                                             game        /game/:id(.:format)                                                                {:controller=>"games", :action=>"show"}
#                              game_wow_characters POST   /games/:game_id/wow_characters(.:format)                                           {:action=>"create", :controller=>"wow_characters"}
#                           new_game_wow_character GET    /games/:game_id/wow_characters/new(.:format)                                       {:action=>"new", :controller=>"wow_characters"}
#                          edit_game_wow_character GET    /games/:game_id/wow_characters/:id/edit(.:format)                                  {:action=>"edit", :controller=>"wow_characters"}
#                               game_wow_character GET    /games/:game_id/wow_characters/:id(.:format)                                       {:action=>"show", :controller=>"wow_characters"}
#                                                  PUT    /games/:game_id/wow_characters/:id(.:format)                                       {:action=>"update", :controller=>"wow_characters"}
#                                                  DELETE /games/:game_id/wow_characters/:id(.:format)                                       {:action=>"destroy", :controller=>"wow_characters"}
#                            game_swtor_characters POST   /games/:game_id/swtor_characters(.:format)                                         {:action=>"create", :controller=>"swtor_characters"}
#                         new_game_swtor_character GET    /games/:game_id/swtor_characters/new(.:format)                                     {:action=>"new", :controller=>"swtor_characters"}
#                        edit_game_swtor_character GET    /games/:game_id/swtor_characters/:id/edit(.:format)                                {:action=>"edit", :controller=>"swtor_characters"}
#                             game_swtor_character GET    /games/:game_id/swtor_characters/:id(.:format)                                     {:action=>"show", :controller=>"swtor_characters"}
#                                                  PUT    /games/:game_id/swtor_characters/:id(.:format)                                     {:action=>"update", :controller=>"swtor_characters"}
#                                                  DELETE /games/:game_id/swtor_characters/:id(.:format)                                     {:action=>"destroy", :controller=>"swtor_characters"}
#                          game_game_announcements POST   /games/:game_id/game_announcements(.:format)                                       {:action=>"create", :controller=>"game_announcements"}
#                       new_game_game_announcement GET    /games/:game_id/game_announcements/new(.:format)                                   {:action=>"new", :controller=>"game_announcements"}
#                                                  GET    /games/:id(.:format)                                                               {:action=>"show", :controller=>"games"}
#                                    wow_character GET    /wow_characters/:id(.:format)                                                      {:action=>"show", :controller=>"wow_characters"}
#                                  swtor_character GET    /swtor_characters/:id(.:format)                                                    {:action=>"show", :controller=>"swtor_characters"}
#                               new_base_character GET    /base_characters/new(.:format)                                                     {:action=>"new", :controller=>"base_characters"}
#                             registration_answers GET    /registration_answers(.:format)                                                    {:action=>"index", :controller=>"registration_answers"}
#                                                  POST   /registration_answers(.:format)                                                    {:action=>"create", :controller=>"registration_answers"}
#                          new_registration_answer GET    /registration_answers/new(.:format)                                                {:action=>"new", :controller=>"registration_answers"}
#                         edit_registration_answer GET    /registration_answers/:id/edit(.:format)                                           {:action=>"edit", :controller=>"registration_answers"}
#                              registration_answer GET    /registration_answers/:id(.:format)                                                {:action=>"show", :controller=>"registration_answers"}
#                                                  PUT    /registration_answers/:id(.:format)                                                {:action=>"update", :controller=>"registration_answers"}
#                                                  DELETE /registration_answers/:id(.:format)                                                {:action=>"destroy", :controller=>"registration_answers"}
#                               text_box_questions GET    /text_box_questions(.:format)                                                      {:action=>"index", :controller=>"text_box_questions"}
#                                                  POST   /text_box_questions(.:format)                                                      {:action=>"create", :controller=>"text_box_questions"}
#                            new_text_box_question GET    /text_box_questions/new(.:format)                                                  {:action=>"new", :controller=>"text_box_questions"}
#                           edit_text_box_question GET    /text_box_questions/:id/edit(.:format)                                             {:action=>"edit", :controller=>"text_box_questions"}
#                                text_box_question GET    /text_box_questions/:id(.:format)                                                  {:action=>"show", :controller=>"text_box_questions"}
#                                                  PUT    /text_box_questions/:id(.:format)                                                  {:action=>"update", :controller=>"text_box_questions"}
#                                                  DELETE /text_box_questions/:id(.:format)                                                  {:action=>"destroy", :controller=>"text_box_questions"}
#                           radio_button_questions GET    /radio_button_questions(.:format)                                                  {:action=>"index", :controller=>"radio_button_questions"}
#                                                  POST   /radio_button_questions(.:format)                                                  {:action=>"create", :controller=>"radio_button_questions"}
#                        new_radio_button_question GET    /radio_button_questions/new(.:format)                                              {:action=>"new", :controller=>"radio_button_questions"}
#                       edit_radio_button_question GET    /radio_button_questions/:id/edit(.:format)                                         {:action=>"edit", :controller=>"radio_button_questions"}
#                            radio_button_question GET    /radio_button_questions/:id(.:format)                                              {:action=>"show", :controller=>"radio_button_questions"}
#                                                  PUT    /radio_button_questions/:id(.:format)                                              {:action=>"update", :controller=>"radio_button_questions"}
#                                                  DELETE /radio_button_questions/:id(.:format)                                              {:action=>"destroy", :controller=>"radio_button_questions"}
#                                   text_questions GET    /text_questions(.:format)                                                          {:action=>"index", :controller=>"text_questions"}
#                                                  POST   /text_questions(.:format)                                                          {:action=>"create", :controller=>"text_questions"}
#                                new_text_question GET    /text_questions/new(.:format)                                                      {:action=>"new", :controller=>"text_questions"}
#                               edit_text_question GET    /text_questions/:id/edit(.:format)                                                 {:action=>"edit", :controller=>"text_questions"}
#                                    text_question GET    /text_questions/:id(.:format)                                                      {:action=>"show", :controller=>"text_questions"}
#                                                  PUT    /text_questions/:id(.:format)                                                      {:action=>"update", :controller=>"text_questions"}
#                                                  DELETE /text_questions/:id(.:format)                                                      {:action=>"destroy", :controller=>"text_questions"}
#                              check_box_questions GET    /check_box_questions(.:format)                                                     {:action=>"index", :controller=>"check_box_questions"}
#                                                  POST   /check_box_questions(.:format)                                                     {:action=>"create", :controller=>"check_box_questions"}
#                           new_check_box_question GET    /check_box_questions/new(.:format)                                                 {:action=>"new", :controller=>"check_box_questions"}
#                          edit_check_box_question GET    /check_box_questions/:id/edit(.:format)                                            {:action=>"edit", :controller=>"check_box_questions"}
#                               check_box_question GET    /check_box_questions/:id(.:format)                                                 {:action=>"show", :controller=>"check_box_questions"}
#                                                  PUT    /check_box_questions/:id(.:format)                                                 {:action=>"update", :controller=>"check_box_questions"}
#                                                  DELETE /check_box_questions/:id(.:format)                                                 {:action=>"destroy", :controller=>"check_box_questions"}
#                              combo_box_questions GET    /combo_box_questions(.:format)                                                     {:action=>"index", :controller=>"combo_box_questions"}
#                                                  POST   /combo_box_questions(.:format)                                                     {:action=>"create", :controller=>"combo_box_questions"}
#                           new_combo_box_question GET    /combo_box_questions/new(.:format)                                                 {:action=>"new", :controller=>"combo_box_questions"}
#                          edit_combo_box_question GET    /combo_box_questions/:id/edit(.:format)                                            {:action=>"edit", :controller=>"combo_box_questions"}
#                               combo_box_question GET    /combo_box_questions/:id(.:format)                                                 {:action=>"show", :controller=>"combo_box_questions"}
#                                                  PUT    /combo_box_questions/:id(.:format)                                                 {:action=>"update", :controller=>"combo_box_questions"}
#                                                  DELETE /combo_box_questions/:id(.:format)                                                 {:action=>"destroy", :controller=>"combo_box_questions"}
#                                          answers GET    /answers(.:format)                                                                 {:action=>"index", :controller=>"answers"}
#                                                  POST   /answers(.:format)                                                                 {:action=>"create", :controller=>"answers"}
#                                       new_answer GET    /answers/new(.:format)                                                             {:action=>"new", :controller=>"answers"}
#                                      edit_answer GET    /answers/:id/edit(.:format)                                                        {:action=>"edit", :controller=>"answers"}
#                                           answer GET    /answers/:id(.:format)                                                             {:action=>"show", :controller=>"answers"}
#                                                  PUT    /answers/:id(.:format)                                                             {:action=>"update", :controller=>"answers"}
#                                                  DELETE /answers/:id(.:format)                                                             {:action=>"destroy", :controller=>"answers"}
#                                     new_question GET    /questions/new(.:format)                                                           {:action=>"new", :controller=>"questions"}
#                                    edit_question GET    /questions/:id/edit(.:format)                                                      {:action=>"edit", :controller=>"questions"}
#                                         question DELETE /questions/:id(.:format)                                                           {:action=>"destroy", :controller=>"questions"}
#                        registration_applications POST   /registration_applications(.:format)                                               {:action=>"create", :controller=>"registration_applications"}
#                     new_registration_application GET    /registration_applications/new(.:format)                                           {:action=>"new", :controller=>"registration_applications"}
#                         registration_application GET    /registration_applications/:id(.:format)                                           {:action=>"show", :controller=>"registration_applications"}
#                     announcement_acknowledgement        /announcement/acknowledge(.:format)                                                {:controller=>"announcement_acknowledgement", :action=>"new"}
#                                 profiles_newgame        /profiles/newgame(.:format)                                                        {:controller=>"profiles", :action=>"newgame"}
#                                            login        /login(.:format)                                                                   {:controller=>"sessions", :action=>"new"}
#                                           logout        /logout(.:format)                                                                  {:controller=>"sessions", :action=>"destroy"}
#                            site_form_submissions GET    /site_forms/:site_form_id/submissions(.:format)                                    {:action=>"index", :controller=>"submissions"}
#                                                  POST   /site_forms/:site_form_id/submissions(.:format)                                    {:action=>"create", :controller=>"submissions"}
#                         new_site_form_submission GET    /site_forms/:site_form_id/submissions/new(.:format)                                {:action=>"new", :controller=>"submissions"}
#                             site_form_submission GET    /site_forms/:site_form_id/submissions/:id(.:format)                                {:action=>"show", :controller=>"submissions"}
#                                       site_forms GET    /site_forms(.:format)                                                              {:action=>"index", :controller=>"site_forms"}
#                                                  POST   /site_forms(.:format)                                                              {:action=>"create", :controller=>"site_forms"}
#                                    new_site_form GET    /site_forms/new(.:format)                                                          {:action=>"new", :controller=>"site_forms"}
#                                   edit_site_form GET    /site_forms/:id/edit(.:format)                                                     {:action=>"edit", :controller=>"site_forms"}
#                                        site_form GET    /site_forms/:id(.:format)                                                          {:action=>"show", :controller=>"site_forms"}
#                                                  PUT    /site_forms/:id(.:format)                                                          {:action=>"update", :controller=>"site_forms"}
#                                                  DELETE /site_forms/:id(.:format)                                                          {:action=>"destroy", :controller=>"site_forms"}
#          profile_acknowledgment_of_announcements GET    /profiles/:profile_id/acknowledgment_of_announcements(.:format)                    {:action=>"index", :controller=>"acknowledgment_of_announcements"}
#                                                  POST   /profiles/:profile_id/acknowledgment_of_announcements(.:format)                    {:action=>"create", :controller=>"acknowledgment_of_announcements"}
#       new_profile_acknowledgment_of_announcement GET    /profiles/:profile_id/acknowledgment_of_announcements/new(.:format)                {:action=>"new", :controller=>"acknowledgment_of_announcements"}
#      edit_profile_acknowledgment_of_announcement GET    /profiles/:profile_id/acknowledgment_of_announcements/:id/edit(.:format)           {:action=>"edit", :controller=>"acknowledgment_of_announcements"}
#           profile_acknowledgment_of_announcement GET    /profiles/:profile_id/acknowledgment_of_announcements/:id(.:format)                {:action=>"show", :controller=>"acknowledgment_of_announcements"}
#                                                  PUT    /profiles/:profile_id/acknowledgment_of_announcements/:id(.:format)                {:action=>"update", :controller=>"acknowledgment_of_announcements"}
#                                                  DELETE /profiles/:profile_id/acknowledgment_of_announcements/:id(.:format)                {:action=>"destroy", :controller=>"acknowledgment_of_announcements"}
#                                         profiles GET    /profiles(.:format)                                                                {:action=>"index", :controller=>"profiles"}
#                                                  POST   /profiles(.:format)                                                                {:action=>"create", :controller=>"profiles"}
#                                      new_profile GET    /profiles/new(.:format)                                                            {:action=>"new", :controller=>"profiles"}
#                                     edit_profile GET    /profiles/:id/edit(.:format)                                                       {:action=>"edit", :controller=>"profiles"}
#                                          profile GET    /profiles/:id(.:format)                                                            {:action=>"show", :controller=>"profiles"}
#                                                  PUT    /profiles/:id(.:format)                                                            {:action=>"update", :controller=>"profiles"}
#                                                  DELETE /profiles/:id(.:format)                                                            {:action=>"destroy", :controller=>"profiles"}
#     game_profile_acknowledgment_of_announcements GET    /game_profiles/:game_profile_id/acknowledgment_of_announcements(.:format)          {:action=>"index", :controller=>"acknowledgment_of_announcements"}
#                                                  POST   /game_profiles/:game_profile_id/acknowledgment_of_announcements(.:format)          {:action=>"create", :controller=>"acknowledgment_of_announcements"}
#  new_game_profile_acknowledgment_of_announcement GET    /game_profiles/:game_profile_id/acknowledgment_of_announcements/new(.:format)      {:action=>"new", :controller=>"acknowledgment_of_announcements"}
# edit_game_profile_acknowledgment_of_announcement GET    /game_profiles/:game_profile_id/acknowledgment_of_announcements/:id/edit(.:format) {:action=>"edit", :controller=>"acknowledgment_of_announcements"}
#      game_profile_acknowledgment_of_announcement GET    /game_profiles/:game_profile_id/acknowledgment_of_announcements/:id(.:format)      {:action=>"show", :controller=>"acknowledgment_of_announcements"}
#                                                  PUT    /game_profiles/:game_profile_id/acknowledgment_of_announcements/:id(.:format)      {:action=>"update", :controller=>"acknowledgment_of_announcements"}
#                                                  DELETE /game_profiles/:game_profile_id/acknowledgment_of_announcements/:id(.:format)      {:action=>"destroy", :controller=>"acknowledgment_of_announcements"}
#                                    game_profiles GET    /game_profiles(.:format)                                                           {:action=>"index", :controller=>"game_profiles"}
#                                                  POST   /game_profiles(.:format)                                                           {:action=>"create", :controller=>"game_profiles"}
#                                 new_game_profile GET    /game_profiles/new(.:format)                                                       {:action=>"new", :controller=>"game_profiles"}
#                                edit_game_profile GET    /game_profiles/:id/edit(.:format)                                                  {:action=>"edit", :controller=>"game_profiles"}
#                                     game_profile GET    /game_profiles/:id(.:format)                                                       {:action=>"show", :controller=>"game_profiles"}
#                                                  PUT    /game_profiles/:id(.:format)                                                       {:action=>"update", :controller=>"game_profiles"}
#                                                  DELETE /game_profiles/:id(.:format)                                                       {:action=>"destroy", :controller=>"game_profiles"}
#     user_profile_acknowledgment_of_announcements GET    /user_profiles/:user_profile_id/acknowledgment_of_announcements(.:format)          {:action=>"index", :controller=>"acknowledgment_of_announcements"}
#                                                  POST   /user_profiles/:user_profile_id/acknowledgment_of_announcements(.:format)          {:action=>"create", :controller=>"acknowledgment_of_announcements"}
#  new_user_profile_acknowledgment_of_announcement GET    /user_profiles/:user_profile_id/acknowledgment_of_announcements/new(.:format)      {:action=>"new", :controller=>"acknowledgment_of_announcements"}
# edit_user_profile_acknowledgment_of_announcement GET    /user_profiles/:user_profile_id/acknowledgment_of_announcements/:id/edit(.:format) {:action=>"edit", :controller=>"acknowledgment_of_announcements"}
#      user_profile_acknowledgment_of_announcement GET    /user_profiles/:user_profile_id/acknowledgment_of_announcements/:id(.:format)      {:action=>"show", :controller=>"acknowledgment_of_announcements"}
#                                                  PUT    /user_profiles/:user_profile_id/acknowledgment_of_announcements/:id(.:format)      {:action=>"update", :controller=>"acknowledgment_of_announcements"}
#                                                  DELETE /user_profiles/:user_profile_id/acknowledgment_of_announcements/:id(.:format)      {:action=>"destroy", :controller=>"acknowledgment_of_announcements"}
#                                    user_profiles GET    /user_profiles(.:format)                                                           {:action=>"index", :controller=>"user_profiles"}
#                                                  POST   /user_profiles(.:format)                                                           {:action=>"create", :controller=>"user_profiles"}
#                                 new_user_profile GET    /user_profiles/new(.:format)                                                       {:action=>"new", :controller=>"user_profiles"}
#                                edit_user_profile GET    /user_profiles/:id/edit(.:format)                                                  {:action=>"edit", :controller=>"user_profiles"}
#                                     user_profile GET    /user_profiles/:id(.:format)                                                       {:action=>"show", :controller=>"user_profiles"}
#                                                  PUT    /user_profiles/:id(.:format)                                                       {:action=>"update", :controller=>"user_profiles"}
#                                                  DELETE /user_profiles/:id(.:format)                                                       {:action=>"destroy", :controller=>"user_profiles"}
#                                          session POST   /session(.:format)                                                                 {:action=>"create", :controller=>"sessions"}
#                                      new_session GET    /session/new(.:format)                                                             {:action=>"new", :controller=>"sessions"}
#                                     edit_session GET    /session/edit(.:format)                                                            {:action=>"edit", :controller=>"sessions"}
#                                                  GET    /session(.:format)                                                                 {:action=>"show", :controller=>"sessions"}
#                                                  PUT    /session(.:format)                                                                 {:action=>"update", :controller=>"sessions"}
#                                                  DELETE /session(.:format)                                                                 {:action=>"destroy", :controller=>"sessions"}
#                                   active_profile        /active_profile/:id/:type(.:format)                                                {:controller=>"active_profiles", :action=>"create"}
#                                      communities GET    /communities(.:format)                                                             {:action=>"index", :controller=>"communities"}
#                                                  POST   /communities(.:format)                                                             {:action=>"create", :controller=>"communities"}
#                                    new_community GET    /communities/new(.:format)                                                         {:action=>"new", :controller=>"communities"}
#                                   edit_community GET    /communities/:id/edit(.:format)                                                    {:action=>"edit", :controller=>"communities"}
#                                        community PUT    /communities/:id(.:format)                                                         {:action=>"update", :controller=>"communities"}
#                                                  DELETE /communities/:id(.:format)                                                         {:action=>"destroy", :controller=>"communities"}
#                                                         /(.:format)                                                                        {:controller=>"subdomains", :action=>"index"}
#                                           search        /search(.:format)                                                                  {:controller=>"subdomains/search", :action=>"index"}
#                                       management        /management(.:format)                                                              {:controller=>"subdomains/management", :action=>"index"}
#                                 management_users GET    /management/users(.:format)                                                        {:action=>"index", :controller=>"subdomains/management/users"}
#                                  management_user DELETE /management/users/:id(.:format)                                                    {:action=>"destroy", :controller=>"subdomains/management/users"}
#                      management_role_permissions POST   /management/roles/:role_id/permissions(.:format)                                   {:action=>"create", :controller=>"subdomains/management/permissions"}
#                   new_management_role_permission GET    /management/roles/:role_id/permissions/new(.:format)                               {:action=>"new", :controller=>"subdomains/management/permissions"}
#                       management_role_permission PUT    /management/roles/:role_id/permissions/:id(.:format)                               {:action=>"update", :controller=>"subdomains/management/permissions"}
#                                                  DELETE /management/roles/:role_id/permissions/:id(.:format)                               {:action=>"destroy", :controller=>"subdomains/management/permissions"}
#                                 management_roles GET    /management/roles(.:format)                                                        {:action=>"index", :controller=>"subdomains/management/roles"}
#                                                  POST   /management/roles(.:format)                                                        {:action=>"create", :controller=>"subdomains/management/roles"}
#                              new_management_role GET    /management/roles/new(.:format)                                                    {:action=>"new", :controller=>"subdomains/management/roles"}
#                             edit_management_role GET    /management/roles/:id/edit(.:format)                                               {:action=>"edit", :controller=>"subdomains/management/roles"}
#                                  management_role GET    /management/roles/:id(.:format)                                                    {:action=>"show", :controller=>"subdomains/management/roles"}
#                                                  PUT    /management/roles/:id(.:format)                                                    {:action=>"update", :controller=>"subdomains/management/roles"}
#                                                  DELETE /management/roles/:id(.:format)                                                    {:action=>"destroy", :controller=>"subdomains/management/roles"}
#                           management_page_spaces GET    /management/page_spaces(.:format)                                                  {:action=>"index", :controller=>"subdomains/management/page_spaces"}
#                                                  POST   /management/page_spaces(.:format)                                                  {:action=>"create", :controller=>"subdomains/management/page_spaces"}
#                        new_management_page_space GET    /management/page_spaces/new(.:format)                                              {:action=>"new", :controller=>"subdomains/management/page_spaces"}
#                       edit_management_page_space GET    /management/page_spaces/:id/edit(.:format)                                         {:action=>"edit", :controller=>"subdomains/management/page_spaces"}
#                            management_page_space GET    /management/page_spaces/:id(.:format)                                              {:action=>"show", :controller=>"subdomains/management/page_spaces"}
#                                                  PUT    /management/page_spaces/:id(.:format)                                              {:action=>"update", :controller=>"subdomains/management/page_spaces"}
#                                                  DELETE /management/page_spaces/:id(.:format)                                              {:action=>"destroy", :controller=>"subdomains/management/page_spaces"}
#                     management_discussion_spaces GET    /management/discussion_spaces(.:format)                                            {:action=>"index", :controller=>"subdomains/management/discussion_spaces"}
#                                                  POST   /management/discussion_spaces(.:format)                                            {:action=>"create", :controller=>"subdomains/management/discussion_spaces"}
#                  new_management_discussion_space GET    /management/discussion_spaces/new(.:format)                                        {:action=>"new", :controller=>"subdomains/management/discussion_spaces"}
#                 edit_management_discussion_space GET    /management/discussion_spaces/:id/edit(.:format)                                   {:action=>"edit", :controller=>"subdomains/management/discussion_spaces"}
#                      management_discussion_space GET    /management/discussion_spaces/:id(.:format)                                        {:action=>"show", :controller=>"subdomains/management/discussion_spaces"}
#                                                  PUT    /management/discussion_spaces/:id(.:format)                                        {:action=>"update", :controller=>"subdomains/management/discussion_spaces"}
#                                                  DELETE /management/discussion_spaces/:id(.:format)                                        {:action=>"destroy", :controller=>"subdomains/management/discussion_spaces"}
#                            management_site_forms GET    /management/site_forms(.:format)                                                   {:action=>"index", :controller=>"subdomains/management/site_forms"}
#                                                  POST   /management/site_forms(.:format)                                                   {:action=>"create", :controller=>"subdomains/management/site_forms"}
#                         new_management_site_form GET    /management/site_forms/new(.:format)                                               {:action=>"new", :controller=>"subdomains/management/site_forms"}
#                        edit_management_site_form GET    /management/site_forms/:id/edit(.:format)                                          {:action=>"edit", :controller=>"subdomains/management/site_forms"}
#                             management_site_form GET    /management/site_forms/:id(.:format)                                               {:action=>"show", :controller=>"subdomains/management/site_forms"}
#                                                  PUT    /management/site_forms/:id(.:format)                                               {:action=>"update", :controller=>"subdomains/management/site_forms"}
#                                                  DELETE /management/site_forms/:id(.:format)                                               {:action=>"destroy", :controller=>"subdomains/management/site_forms"}
#       accept_management_registration_application POST   /management/registration_applications/:id/accept(.:format)                         {:action=>"accept", :controller=>"subdomains/management/registration_applications"}
#       reject_management_registration_application POST   /management/registration_applications/:id/reject(.:format)                         {:action=>"reject", :controller=>"subdomains/management/registration_applications"}
#             management_registration_applications GET    /management/registration_applications(.:format)                                    {:action=>"index", :controller=>"subdomains/management/registration_applications"}
#         edit_management_registration_application GET    /management/registration_applications/:id/edit(.:format)                           {:action=>"edit", :controller=>"subdomains/management/registration_applications"}
#              management_registration_application GET    /management/registration_applications/:id(.:format)                                {:action=>"show", :controller=>"subdomains/management/registration_applications"}
#                                                  PUT    /management/registration_applications/:id(.:format)                                {:action=>"update", :controller=>"subdomains/management/registration_applications"}
#                                                  DELETE /management/registration_applications/:id(.:format)                                {:action=>"destroy", :controller=>"subdomains/management/registration_applications"}
#                                     lock_comment POST   /comments/:id/lock(.:format)                                                       {:action=>"lock", :controller=>"subdomains/comments"}
#                                   unlock_comment POST   /comments/:id/unlock(.:format)                                                     {:action=>"unlock", :controller=>"subdomains/comments"}
#                                         comments GET    /comments(.:format)                                                                {:action=>"index", :controller=>"subdomains/comments"}
#                                                  POST   /comments(.:format)                                                                {:action=>"create", :controller=>"subdomains/comments"}
#                                      new_comment GET    /comments/new(.:format)                                                            {:action=>"new", :controller=>"subdomains/comments"}
#                                     edit_comment GET    /comments/:id/edit(.:format)                                                       {:action=>"edit", :controller=>"subdomains/comments"}
#                                          comment GET    /comments/:id(.:format)                                                            {:action=>"show", :controller=>"subdomains/comments"}
#                                                  PUT    /comments/:id(.:format)                                                            {:action=>"update", :controller=>"subdomains/comments"}
#                                                  DELETE /comments/:id(.:format)                                                            {:action=>"destroy", :controller=>"subdomains/comments"}
#                     discussion_space_discussions POST   /discussion_spaces/:discussion_space_id/discussions(.:format)                      {:action=>"create", :controller=>"subdomains/subdomains/discussion_spaces/discussions"}
#                  new_discussion_space_discussion GET    /discussion_spaces/:discussion_space_id/discussions/new(.:format)                  {:action=>"new", :controller=>"subdomains/subdomains/discussion_spaces/discussions"}
#                                discussion_spaces GET    /discussion_spaces(.:format)                                                       {:action=>"index", :controller=>"subdomains/discussion_spaces"}
#                                                  POST   /discussion_spaces(.:format)                                                       {:action=>"create", :controller=>"subdomains/discussion_spaces"}
#                             new_discussion_space GET    /discussion_spaces/new(.:format)                                                   {:action=>"new", :controller=>"subdomains/discussion_spaces"}
#                            edit_discussion_space GET    /discussion_spaces/:id/edit(.:format)                                              {:action=>"edit", :controller=>"subdomains/discussion_spaces"}
#                                 discussion_space GET    /discussion_spaces/:id(.:format)                                                   {:action=>"show", :controller=>"subdomains/discussion_spaces"}
#                                                  PUT    /discussion_spaces/:id(.:format)                                                   {:action=>"update", :controller=>"subdomains/discussion_spaces"}
#                                                  DELETE /discussion_spaces/:id(.:format)                                                   {:action=>"destroy", :controller=>"subdomains/discussion_spaces"}
#                                  lock_discussion POST   /discussions/:id/lock(.:format)                                                    {:action=>"lock", :controller=>"subdomains/discussions"}
#                                unlock_discussion POST   /discussions/:id/unlock(.:format)                                                  {:action=>"unlock", :controller=>"subdomains/discussions"}
#                                  edit_discussion GET    /discussions/:id/edit(.:format)                                                    {:action=>"edit", :controller=>"subdomains/discussions"}
#                                       discussion GET    /discussions/:id(.:format)                                                         {:action=>"show", :controller=>"subdomains/discussions"}
#                                                  PUT    /discussions/:id(.:format)                                                         {:action=>"update", :controller=>"subdomains/discussions"}
#                                                  DELETE /discussions/:id(.:format)                                                         {:action=>"destroy", :controller=>"subdomains/discussions"}
#                                 page_space_pages GET    /page_spaces/:page_space_id/pages(.:format)                                        {:action=>"index", :controller=>"subdomains/pages"}
#                                                  POST   /page_spaces/:page_space_id/pages(.:format)                                        {:action=>"create", :controller=>"subdomains/pages"}
#                              new_page_space_page GET    /page_spaces/:page_space_id/pages/new(.:format)                                    {:action=>"new", :controller=>"subdomains/pages"}
#                             edit_page_space_page GET    /page_spaces/:page_space_id/pages/:id/edit(.:format)                               {:action=>"edit", :controller=>"subdomains/pages"}
#                                  page_space_page GET    /page_spaces/:page_space_id/pages/:id(.:format)                                    {:action=>"show", :controller=>"subdomains/pages"}
#                                                  PUT    /page_spaces/:page_space_id/pages/:id(.:format)                                    {:action=>"update", :controller=>"subdomains/pages"}
#                                                  DELETE /page_spaces/:page_space_id/pages/:id(.:format)                                    {:action=>"destroy", :controller=>"subdomains/pages"}
#                                      page_spaces GET    /page_spaces(.:format)                                                             {:action=>"index", :controller=>"subdomains/page_spaces"}
#                                                  POST   /page_spaces(.:format)                                                             {:action=>"create", :controller=>"subdomains/page_spaces"}
#                                   new_page_space GET    /page_spaces/new(.:format)                                                         {:action=>"new", :controller=>"subdomains/page_spaces"}
#                                  edit_page_space GET    /page_spaces/:id/edit(.:format)                                                    {:action=>"edit", :controller=>"subdomains/page_spaces"}
#                                       page_space GET    /page_spaces/:id(.:format)                                                         {:action=>"show", :controller=>"subdomains/page_spaces"}
#                                                  PUT    /page_spaces/:id(.:format)                                                         {:action=>"update", :controller=>"subdomains/page_spaces"}
#                                                  DELETE /page_spaces/:id(.:format)                                                         {:action=>"destroy", :controller=>"subdomains/page_spaces"}
#                               game_announcements GET    /game_announcements(.:format)                                                      {:action=>"index", :controller=>"subdomains/game_announcements"}
#                                                  POST   /game_announcements(.:format)                                                      {:action=>"create", :controller=>"subdomains/game_announcements"}
#                            new_game_announcement GET    /game_announcements/new(.:format)                                                  {:action=>"new", :controller=>"subdomains/game_announcements"}
#                           edit_game_announcement GET    /game_announcements/:id/edit(.:format)                                             {:action=>"edit", :controller=>"subdomains/game_announcements"}
#                                game_announcement GET    /game_announcements/:id(.:format)                                                  {:action=>"show", :controller=>"subdomains/game_announcements"}
#                                                  PUT    /game_announcements/:id(.:format)                                                  {:action=>"update", :controller=>"subdomains/game_announcements"}
#                                                  DELETE /game_announcements/:id(.:format)                                                  {:action=>"destroy", :controller=>"subdomains/game_announcements"}
#                          community_announcements GET    /community_announcements(.:format)                                                 {:action=>"index", :controller=>"subdomains/community_announcements"}
#                                                  POST   /community_announcements(.:format)                                                 {:action=>"create", :controller=>"subdomains/community_announcements"}
#                       new_community_announcement GET    /community_announcements/new(.:format)                                             {:action=>"new", :controller=>"subdomains/community_announcements"}
#                      edit_community_announcement GET    /community_announcements/:id/edit(.:format)                                        {:action=>"edit", :controller=>"subdomains/community_announcements"}
#                           community_announcement GET    /community_announcements/:id(.:format)                                             {:action=>"show", :controller=>"subdomains/community_announcements"}
#                                                  PUT    /community_announcements/:id(.:format)                                             {:action=>"update", :controller=>"subdomains/community_announcements"}
#                                                  DELETE /community_announcements/:id(.:format)                                             {:action=>"destroy", :controller=>"subdomains/community_announcements"}
#                                    announcements GET    /announcements(.:format)                                                           {:action=>"index", :controller=>"announcements"}
#                                                  POST   /announcements(.:format)                                                           {:action=>"create", :controller=>"announcements"}
#                                 new_announcement GET    /announcements/new(.:format)                                                       {:action=>"new", :controller=>"announcements"}
#                                edit_announcement GET    /announcements/:id/edit(.:format)                                                  {:action=>"edit", :controller=>"announcements"}
#                                     announcement GET    /announcements/:id(.:format)                                                       {:action=>"show", :controller=>"announcements"}
#                                                  PUT    /announcements/:id(.:format)                                                       {:action=>"update", :controller=>"announcements"}
#                                                  DELETE /announcements/:id(.:format)                                                       {:action=>"destroy", :controller=>"announcements"}
#                               site_announcements GET    /site_announcements(.:format)                                                      {:action=>"index", :controller=>"site_announcements"}
#                                                  POST   /site_announcements(.:format)                                                      {:action=>"create", :controller=>"site_announcements"}
#                            new_site_announcement GET    /site_announcements/new(.:format)                                                  {:action=>"new", :controller=>"site_announcements"}
#                           edit_site_announcement GET    /site_announcements/:id/edit(.:format)                                             {:action=>"edit", :controller=>"site_announcements"}
#                                site_announcement GET    /site_announcements/:id(.:format)                                                  {:action=>"show", :controller=>"site_announcements"}
#                                                  PUT    /site_announcements/:id(.:format)                                                  {:action=>"update", :controller=>"site_announcements"}
#                                                  DELETE /site_announcements/:id(.:format)                                                  {:action=>"destroy", :controller=>"site_announcements"}
#                                                  GET    /game_announcements/:id(.:format)                                                  {:action=>"show", :controller=>"announcements"}
#                                                  GET    /community_announcements/:id(.:format)                                             {:action=>"show", :controller=>"announcements"}
#                                             root        /(.:format)                                                                        {:controller=>"home", :action=>"index"}
#                                       status_404        /404(.:format)                                                                     {:controller=>"status_code", :action=>"invoke_404"}
#                                                         /*path                                                                             {:controller=>"status_code", :action=>"invoke_404"}

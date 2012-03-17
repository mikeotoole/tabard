# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120317181635) do

  create_table "acknowledgements", :force => true do |t|
    t.integer  "community_profile_id"
    t.integer  "announcement_id"
    t.boolean  "has_been_viewed",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "acknowledgements", ["announcement_id"], :name => "index_acknowledgements_on_announcement_id"
  add_index "acknowledgements", ["community_profile_id"], :name => "index_acknowledgements_on_community_profile_id"

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "activities", :force => true do |t|
    t.integer  "user_profile_id"
    t.integer  "community_id"
    t.string   "target_type"
    t.integer  "target_id"
    t.string   "action"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["community_id"], :name => "index_activities_on_community_id"
  add_index "activities", ["target_type", "target_id"], :name => "index_activities_on_target_type_and_target_id"
  add_index "activities", ["user_profile_id"], :name => "index_activities_on_user_profile_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "announcements", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "character_proxy_id"
    t.integer  "user_profile_id"
    t.integer  "community_id"
    t.integer  "supported_game_id"
    t.boolean  "is_locked",          :default => false
    t.datetime "deleted_at"
    t.boolean  "has_been_edited",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "announcements", ["character_proxy_id"], :name => "index_announcements_on_character_proxy_id"
  add_index "announcements", ["community_id"], :name => "index_announcements_on_community_id"
  add_index "announcements", ["supported_game_id"], :name => "index_announcements_on_supported_game_id"
  add_index "announcements", ["user_profile_id"], :name => "index_announcements_on_user_profile_id"

  create_table "answers", :force => true do |t|
    t.text     "body"
    t.integer  "submission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "question_body"
  end

  add_index "answers", ["submission_id"], :name => "index_answers_on_submission_id"

  create_table "artwork_uploads", :force => true do |t|
    t.string   "owner_name"
    t.string   "email"
    t.string   "street"
    t.string   "city"
    t.string   "zipcode"
    t.string   "state"
    t.string   "country"
    t.string   "attribution_name"
    t.string   "attribution_url"
    t.string   "artwork_image"
    t.string   "artwork_description"
    t.boolean  "certify_owner_of_artwork"
    t.integer  "document_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "artwork_uploads", ["document_id"], :name => "index_artwork_uploads_on_document_id"

  create_table "character_proxies", :force => true do |t|
    t.integer  "user_profile_id"
    t.integer  "character_id"
    t.string   "character_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_removed",      :default => false
  end

  add_index "character_proxies", ["character_type", "character_id"], :name => "index_proxies_on_character_type_and_character_id", :unique => true
  add_index "character_proxies", ["user_profile_id"], :name => "index_character_proxies_on_user_profile_id"

  create_table "character_proxies_community_applications", :id => false, :force => true do |t|
    t.integer "character_proxy_id"
    t.integer "community_application_id"
  end

  add_index "character_proxies_community_applications", ["character_proxy_id"], :name => "habtm_cproxy_app_proxy_id"
  add_index "character_proxies_community_applications", ["community_application_id"], :name => "habtm_cproxy_app_app_id"

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "user_profile_id"
    t.integer  "character_proxy_id"
    t.integer  "community_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.boolean  "is_removed",                :default => false
    t.boolean  "has_been_edited",           :default => false
    t.boolean  "is_locked",                 :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "original_commentable_id"
    t.string   "original_commentable_type"
    t.datetime "deleted_at"
  end

  add_index "comments", ["character_proxy_id"], :name => "index_comments_on_character_proxy_id"
  add_index "comments", ["commentable_type", "commentable_id"], :name => "index_comments_on_commentable_type_and_id"
  add_index "comments", ["community_id"], :name => "index_comments_on_community_id"
  add_index "comments", ["original_commentable_id", "original_commentable_type"], :name => "index_comments_original_commentable"
  add_index "comments", ["user_profile_id"], :name => "index_comments_on_user_profile_id"

  create_table "communities", :force => true do |t|
    t.string   "name"
    t.string   "slogan"
    t.boolean  "is_accepting_members",            :default => true
    t.boolean  "email_notice_on_application",     :default => true
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_profile_id"
    t.integer  "member_role_id"
    t.boolean  "is_protected_roster",             :default => false
    t.integer  "community_application_form_id"
    t.integer  "community_announcement_space_id"
    t.boolean  "is_public_roster",                :default => true
    t.datetime "deleted_at"
    t.string   "background_image"
    t.string   "background_color"
    t.integer  "theme_id"
    t.string   "title_color"
    t.integer  "home_page_id"
    t.boolean  "pending_removal",                 :default => false
    t.text     "action_items"
    t.text     "pitch"
  end

  add_index "communities", ["admin_profile_id"], :name => "index_communities_on_admin_profile_id"
  add_index "communities", ["community_announcement_space_id"], :name => "index_communities_on_community_announcement_space_id"
  add_index "communities", ["community_application_form_id"], :name => "index_communities_on_community_application_form_id", :unique => true
  add_index "communities", ["home_page_id"], :name => "index_communities_on_home_page_id"
  add_index "communities", ["member_role_id"], :name => "index_communities_on_member_role_id", :unique => true
  add_index "communities", ["name"], :name => "index_communities_on_name"
  add_index "communities", ["theme_id"], :name => "index_communities_on_theme_id"

  create_table "community_applications", :force => true do |t|
    t.integer  "community_id"
    t.integer  "user_profile_id"
    t.integer  "submission_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_changer_id"
    t.datetime "deleted_at"
  end

  add_index "community_applications", ["community_id"], :name => "index_community_applications_on_community_id"
  add_index "community_applications", ["status_changer_id"], :name => "index_community_applications_on_status_changer_id"
  add_index "community_applications", ["submission_id"], :name => "index_community_applications_on_submission_id"
  add_index "community_applications", ["user_profile_id"], :name => "index_community_applications_on_user_profile_id"

  create_table "community_profiles", :force => true do |t|
    t.integer  "community_id"
    t.integer  "user_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "community_application_id"
  end

  add_index "community_profiles", ["community_application_id"], :name => "index_community_profiles_on_community_application_id"
  add_index "community_profiles", ["community_id"], :name => "index_community_profiles_on_community_id"
  add_index "community_profiles", ["user_profile_id"], :name => "index_community_profiles_on_user_profile_id"

  create_table "community_profiles_roles", :id => false, :force => true do |t|
    t.integer  "community_profile_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "community_profiles_roles", ["community_profile_id"], :name => "index_community_profiles_roles_on_community_profile_id"
  add_index "community_profiles_roles", ["role_id"], :name => "index_community_profiles_roles_on_role_id"

  create_table "custom_forms", :force => true do |t|
    t.string   "name"
    t.text     "instructions"
    t.string   "thankyou"
    t.boolean  "is_published", :default => false
    t.integer  "community_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "custom_forms", ["community_id"], :name => "index_custom_forms_on_community_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "discussion_spaces", :force => true do |t|
    t.string   "name"
    t.integer  "supported_game_id"
    t.integer  "community_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_announcement_space", :default => false
    t.datetime "deleted_at"
  end

  add_index "discussion_spaces", ["community_id"], :name => "index_discussion_spaces_on_community_id"
  add_index "discussion_spaces", ["supported_game_id"], :name => "index_discussion_spaces_on_game_id"

  create_table "discussions", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "discussion_space_id"
    t.integer  "character_proxy_id"
    t.integer  "user_profile_id"
    t.boolean  "is_locked",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean  "has_been_edited",     :default => false
  end

  add_index "discussions", ["character_proxy_id"], :name => "index_discussions_on_character_proxy_id"
  add_index "discussions", ["discussion_space_id"], :name => "index_discussions_on_discussion_space_id"
  add_index "discussions", ["user_profile_id"], :name => "index_discussions_on_user_profile_id"

  create_table "document_acceptances", :force => true do |t|
    t.integer  "user_id"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "document_acceptances", ["document_id"], :name => "index_document_acceptances_on_document_id"
  add_index "document_acceptances", ["user_id"], :name => "index_document_acceptances_on_user_id"

  create_table "documents", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version"
    t.boolean  "is_published", :default => false
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "creator_id"
    t.integer  "supported_game_id"
    t.integer  "community_id"
    t.boolean  "is_public",         :default => false
    t.string   "location"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "events", ["community_id"], :name => "index_events_on_community_id"
  add_index "events", ["creator_id"], :name => "index_events_on_creator_id"
  add_index "events", ["supported_game_id"], :name => "index_events_on_supported_game_id"

  create_table "folders", :force => true do |t|
    t.string   "name"
    t.integer  "user_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "folders", ["user_profile_id"], :name => "index_folders_on_user_profile_id"

  create_table "games", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "pretty_url"
  end

  create_table "invites", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_profile_id"
    t.integer  "character_proxy_id"
    t.string   "status"
    t.boolean  "is_viewed",          :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "invites", ["character_proxy_id"], :name => "index_invites_on_character_proxy_id"
  add_index "invites", ["event_id"], :name => "index_invites_on_event_id"
  add_index "invites", ["user_profile_id"], :name => "index_invites_on_user_profile_id"

  create_table "message_associations", :force => true do |t|
    t.integer  "message_id"
    t.integer  "recipient_id"
    t.integer  "folder_id"
    t.boolean  "is_removed",    :default => false
    t.boolean  "has_been_read", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_associations", ["folder_id"], :name => "index_message_associations_on_folder_id"
  add_index "message_associations", ["message_id"], :name => "index_message_associations_on_message_id"
  add_index "message_associations", ["recipient_id"], :name => "index_message_associations_on_recipient_id"

  create_table "messages", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "author_id"
    t.integer  "number_recipients"
    t.boolean  "is_system_sent",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["author_id"], :name => "index_messages_on_author_id"

  create_table "minecraft_characters", :force => true do |t|
    t.string   "name"
    t.string   "avatar"
    t.text     "about"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "minecrafts", :force => true do |t|
    t.string   "server_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "page_spaces", :force => true do |t|
    t.string   "name"
    t.integer  "supported_game_id"
    t.integer  "community_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "page_spaces", ["community_id"], :name => "index_page_spaces_on_community_id"
  add_index "page_spaces", ["supported_game_id"], :name => "index_page_spaces_on_game_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "markup"
    t.integer  "page_space_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "pages", ["page_space_id"], :name => "index_pages_on_page_space_id"

  create_table "permission_defaults", :force => true do |t|
    t.integer  "role_id"
    t.string   "object_class"
    t.string   "permission_level"
    t.boolean  "can_read",                :default => false
    t.boolean  "can_update",              :default => false
    t.boolean  "can_create",              :default => false
    t.boolean  "can_destroy",             :default => false
    t.boolean  "can_lock",                :default => false
    t.boolean  "can_accept",              :default => false
    t.string   "nested_permission_level"
    t.boolean  "can_read_nested",         :default => false
    t.boolean  "can_update_nested",       :default => false
    t.boolean  "can_create_nested",       :default => false
    t.boolean  "can_destroy_nested",      :default => false
    t.boolean  "can_lock_nested",         :default => false
    t.boolean  "can_accept_nested",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "permission_defaults", ["role_id"], :name => "index_permission_defaults_on_role_id"

  create_table "permissions", :force => true do |t|
    t.integer  "role_id"
    t.string   "permission_level"
    t.string   "subject_class"
    t.integer  "id_of_subject",                  :limit => 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "can_lock",                                      :default => false
    t.boolean  "can_accept",                                    :default => false
    t.string   "parent_association_for_subject"
    t.integer  "id_of_parent"
    t.boolean  "can_read",                                      :default => false
    t.boolean  "can_create",                                    :default => false
    t.boolean  "can_update",                                    :default => false
    t.boolean  "can_destroy",                                   :default => false
    t.datetime "deleted_at"
  end

  add_index "permissions", ["role_id"], :name => "index_permissions_on_role_id"

  create_table "predefined_answers", :force => true do |t|
    t.text     "body"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "position",    :default => 0
  end

  add_index "predefined_answers", ["question_id"], :name => "index_predefined_answers_on_select_question_id"

  create_table "questions", :force => true do |t|
    t.text     "body"
    t.integer  "custom_form_id"
    t.string   "style"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "explanation"
    t.boolean  "is_required",    :default => false
    t.datetime "deleted_at"
    t.integer  "position",       :default => 0
  end

  add_index "questions", ["custom_form_id"], :name => "index_questions_on_custom_form_id"

  create_table "roles", :force => true do |t|
    t.integer  "community_id"
    t.string   "name"
    t.boolean  "is_system_generated", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "roles", ["community_id"], :name => "index_roles_on_community_id"

  create_table "roster_assignments", :force => true do |t|
    t.integer  "community_profile_id"
    t.integer  "character_proxy_id"
    t.boolean  "is_pending",           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "supported_game_id"
  end

  add_index "roster_assignments", ["character_proxy_id"], :name => "index_roster_assignments_on_character_proxy_id"
  add_index "roster_assignments", ["community_profile_id"], :name => "index_roster_assignments_on_community_profile_id"
  add_index "roster_assignments", ["supported_game_id"], :name => "index_roster_assignments_on_supported_game_id"

  create_table "site_configurations", :force => true do |t|
    t.boolean  "is_maintenance", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submissions", :force => true do |t|
    t.integer  "custom_form_id"
    t.integer  "user_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "submissions", ["custom_form_id"], :name => "index_submissions_on_custom_form_id"
  add_index "submissions", ["user_profile_id"], :name => "index_submissions_on_user_profile_id"

  create_table "supported_games", :force => true do |t|
    t.integer  "community_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_announcement_space_id"
    t.string   "name"
    t.string   "game_type"
    t.datetime "deleted_at"
  end

  add_index "supported_games", ["community_id"], :name => "index_supported_games_on_community_id"
  add_index "supported_games", ["game_announcement_space_id"], :name => "index_supported_games_on_game_announcement_space_id"
  add_index "supported_games", ["game_id", "game_type"], :name => "index_supported_games_on_game_id_and_game_type"

  create_table "swtor_characters", :force => true do |t|
    t.string   "name"
    t.integer  "swtor_id"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "char_class"
    t.string   "advanced_class"
    t.string   "species"
    t.string   "level"
    t.string   "about"
    t.string   "gender"
  end

  add_index "swtor_characters", ["swtor_id"], :name => "index_swtor_characters_on_game_id"

  create_table "swtors", :force => true do |t|
    t.string   "faction"
    t.string   "server_name"
    t.string   "server_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "themes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "css"
    t.string   "background_author"
    t.string   "background_author_url"
    t.string   "thumbnail"
  end

  create_table "user_profiles", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "display_name"
    t.boolean  "publicly_viewable", :default => true
    t.string   "title"
    t.string   "location"
  end

  add_index "user_profiles", ["display_name"], :name => "index_user_profiles_on_display_name"
  add_index "user_profiles", ["location"], :name => "index_user_profiles_on_location"

  create_table "users", :force => true do |t|
    t.string   "email",                                            :default => "",    :null => false
    t.string   "encrypted_password",                :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                                  :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted_current_terms_of_service",                :default => false
    t.boolean  "accepted_current_privacy_policy",                  :default => false
    t.boolean  "force_logout",                                     :default => false
    t.date     "date_of_birth"
    t.datetime "user_disabled_at"
    t.datetime "admin_disabled_at"
    t.integer  "user_profile_id"
    t.string   "time_zone"
    t.boolean  "is_email_on_message",                              :default => true
    t.boolean  "is_email_on_announcement",                         :default => true
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
  add_index "users", ["user_profile_id"], :name => "index_users_on_user_profile_id", :unique => true

  create_table "view_logs", :force => true do |t|
    t.integer  "user_profile_id"
    t.integer  "view_loggable_id"
    t.string   "view_loggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "view_logs", ["user_profile_id"], :name => "index_view_logs_on_user_profile_id"
  add_index "view_logs", ["view_loggable_type", "view_loggable_id"], :name => "index_view_logs_on_view_loggable_type_and_id"

  create_table "wow_characters", :force => true do |t|
    t.string   "name"
    t.string   "race"
    t.integer  "level"
    t.integer  "wow_id"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "char_class"
    t.text     "about"
    t.string   "gender"
  end

  add_index "wow_characters", ["wow_id"], :name => "index_wow_characters_on_game_id"

  create_table "wows", :force => true do |t|
    t.string   "faction"
    t.string   "server_name"
    t.string   "server_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

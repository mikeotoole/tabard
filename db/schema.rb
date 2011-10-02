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

ActiveRecord::Schema.define(:version => 20111001023510) do

  create_table "answers", :force => true do |t|
    t.text     "body"
    t.integer  "question_id"
    t.integer  "submission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["submission_id"], :name => "index_answers_on_submission_id"

  create_table "character_proxies", :force => true do |t|
    t.integer  "user_profile_id"
    t.integer  "character_id"
    t.string   "character_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default_character", :default => false
  end

  add_index "character_proxies", ["character_type", "character_id"], :name => "index_proxies_on_character_type_and_character_id"
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
    t.boolean  "has_been_deleted",   :default => false
    t.boolean  "has_been_edited",    :default => false
    t.boolean  "has_been_locked",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["character_proxy_id"], :name => "index_comments_on_character_proxy_id"
  add_index "comments", ["commentable_type", "commentable_id"], :name => "index_comments_on_commentable_type_and_id"
  add_index "comments", ["community_id"], :name => "index_comments_on_community_id"
  add_index "comments", ["user_profile_id"], :name => "index_comments_on_user_profile_id"

  create_table "communities", :force => true do |t|
    t.string   "name"
    t.string   "slogan"
    t.boolean  "accepting_members",               :default => true
    t.boolean  "email_notice_on_application",     :default => true
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_profile_id"
    t.integer  "member_role_id"
    t.boolean  "protected_roster",                :default => false
    t.integer  "community_application_form_id"
    t.integer  "community_announcement_space_id"
  end

  add_index "communities", ["admin_profile_id"], :name => "index_communities_on_admin_profile_id"
  add_index "communities", ["community_announcement_space_id"], :name => "index_communities_on_community_announcement_space_id"
  add_index "communities", ["community_application_form_id"], :name => "index_communities_on_community_application_form_id"
  add_index "communities", ["member_role_id"], :name => "index_communities_on_member_role_id"

  create_table "community_applications", :force => true do |t|
    t.integer  "community_id"
    t.integer  "user_profile_id"
    t.integer  "submission_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "community_applications", ["community_id"], :name => "index_community_applications_on_community_id"
  add_index "community_applications", ["submission_id"], :name => "index_community_applications_on_submission_id"
  add_index "community_applications", ["user_profile_id"], :name => "index_community_applications_on_user_profile_id"

  create_table "community_profiles", :force => true do |t|
    t.integer  "community_id"
    t.integer  "user_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.boolean  "published",    :default => false
    t.integer  "community_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_forms", ["community_id"], :name => "index_custom_forms_on_community_id"

  create_table "discussion_spaces", :force => true do |t|
    t.string   "name"
    t.integer  "user_profile_id"
    t.integer  "game_id"
    t.integer  "community_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_announcement", :default => false
  end

  add_index "discussion_spaces", ["community_id"], :name => "index_discussion_spaces_on_community_id"
  add_index "discussion_spaces", ["game_id"], :name => "index_discussion_spaces_on_game_id"
  add_index "discussion_spaces", ["user_profile_id"], :name => "index_discussion_spaces_on_user_profile_id"

  create_table "discussions", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "discussion_space_id"
    t.integer  "character_proxy_id"
    t.integer  "user_profile_id"
    t.boolean  "comments_enabled",    :default => true
    t.boolean  "has_been_locked",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_archived",         :default => false
  end

  add_index "discussions", ["character_proxy_id"], :name => "index_discussions_on_character_proxy_id"
  add_index "discussions", ["discussion_space_id"], :name => "index_discussions_on_discussion_space_id"
  add_index "discussions", ["user_profile_id"], :name => "index_discussions_on_user_profile_id"

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pretty_url"
  end

  create_table "message_associations", :force => true do |t|
    t.integer  "message_id"
    t.integer  "recipient_id"
    t.integer  "folder_id"
    t.boolean  "deleted",      :default => false
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
    t.boolean  "system_sent",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["author_id"], :name => "index_messages_on_author_id"

  create_table "page_spaces", :force => true do |t|
    t.string   "name"
    t.integer  "user_profile_id"
    t.integer  "game_id"
    t.integer  "community_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_spaces", ["community_id"], :name => "index_page_spaces_on_community_id"
  add_index "page_spaces", ["game_id"], :name => "index_page_spaces_on_game_id"
  add_index "page_spaces", ["user_profile_id"], :name => "index_page_spaces_on_user_profile_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "markup"
    t.integer  "character_proxy_id"
    t.integer  "user_profile_id"
    t.integer  "page_space_id"
    t.boolean  "show_in_navigation", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["character_proxy_id"], :name => "index_pages_on_character_proxy_id"
  add_index "pages", ["page_space_id"], :name => "index_pages_on_page_space_id"
  add_index "pages", ["user_profile_id"], :name => "index_pages_on_user_profile_id"

  create_table "permissions", :force => true do |t|
    t.integer  "role_id"
    t.string   "action"
    t.string   "permission_level"
    t.string   "subject_class"
    t.string   "id_of_subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["role_id"], :name => "index_permissions_on_role_id"

  create_table "predefined_answers", :force => true do |t|
    t.text     "body"
    t.integer  "select_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "predefined_answers", ["select_question_id"], :name => "index_predefined_answers_on_select_question_id"

  create_table "questions", :force => true do |t|
    t.text     "body"
    t.integer  "custom_form_id"
    t.string   "type"
    t.string   "style"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "explanation"
    t.boolean  "required",       :default => false
  end

  add_index "questions", ["custom_form_id"], :name => "index_questions_on_custom_form_id"

  create_table "roles", :force => true do |t|
    t.integer  "community_id"
    t.string   "name"
    t.boolean  "system_generated", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["community_id"], :name => "index_roles_on_community_id"

  create_table "roster_assignments", :force => true do |t|
    t.integer  "community_profile_id"
    t.integer  "character_proxy_id"
    t.boolean  "pending",              :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roster_assignments", ["character_proxy_id"], :name => "index_roster_assignments_on_character_proxy_id"
  add_index "roster_assignments", ["community_profile_id"], :name => "index_roster_assignments_on_community_profile_id"

  create_table "submissions", :force => true do |t|
    t.integer  "custom_form_id"
    t.integer  "user_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "submissions", ["custom_form_id"], :name => "index_submissions_on_custom_form_id"
  add_index "submissions", ["user_profile_id"], :name => "index_submissions_on_user_profile_id"

  create_table "supported_games", :force => true do |t|
    t.integer  "community_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_announcement_space_id"
  end

  add_index "supported_games", ["community_id"], :name => "index_supported_games_on_community_id"
  add_index "supported_games", ["game_announcement_space_id"], :name => "index_supported_games_on_game_announcement_space_id"
  add_index "supported_games", ["game_id"], :name => "index_supported_games_on_game_id"

  create_table "swtor_characters", :force => true do |t|
    t.string   "name"
    t.string   "server"
    t.integer  "game_id"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "swtor_characters", ["game_id"], :name => "index_swtor_characters_on_game_id"

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "display_name"
    t.boolean  "publicly_viewable", :default => true
  end

  add_index "user_profiles", ["user_id"], :name => "index_user_profiles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "view_logs", :force => true do |t|
    t.integer  "user_profile_id"
    t.integer  "view_loggable_id"
    t.string   "view_loggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "view_logs", ["user_profile_id"], :name => "index_view_logs_on_user_profile_id"
  add_index "view_logs", ["view_loggable_type", "view_loggable_id"], :name => "index_view_logs_on_view_loggable_type_and_id"

  create_table "wow_characters", :force => true do |t|
    t.string   "name"
    t.string   "faction"
    t.string   "race"
    t.integer  "level"
    t.string   "server"
    t.integer  "game_id"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wow_characters", ["game_id"], :name => "index_wow_characters_on_game_id"

end

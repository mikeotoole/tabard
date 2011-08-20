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

ActiveRecord::Schema.define(:version => 20110820181631) do

  create_table "acknowledgment_of_announcements", :force => true do |t|
    t.integer  "announcement_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "acknowledged",    :default => false
  end

  add_index "acknowledgment_of_announcements", ["announcement_id"], :name => "index_acknowledgment_of_announcements_on_announcement_id"
  add_index "acknowledgment_of_announcements", ["profile_id"], :name => "index_acknowledgment_of_announcements_on_profile_id"

  create_table "announcements", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "user_profile_id"
    t.integer  "game_id"
    t.integer  "community_id"
    t.string   "type"
    t.boolean  "comments_enabled", :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "announcements", ["community_id"], :name => "index_announcements_on_community_id"
  add_index "announcements", ["game_id"], :name => "index_announcements_on_game_id"
  add_index "announcements", ["user_profile_id"], :name => "index_announcements_on_user_profile_id"

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "submission_id"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["submission_id"], :name => "index_answers_on_submission_id"

  create_table "character_proxies", :force => true do |t|
    t.integer  "game_profile_id"
    t.integer  "character_id"
    t.string   "character_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "character_proxies", ["character_id", "character_type"], :name => "index_character_proxies_on_character_id_and_character_type"
  add_index "character_proxies", ["game_profile_id"], :name => "index_character_proxies_on_game_profile_id"

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "character_proxy_id"
    t.integer  "user_profile_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_been_deleted",   :default => false
    t.boolean  "has_been_edited",    :default => false
    t.boolean  "has_been_locked",    :default => false
    t.integer  "community_id"
  end

  add_index "comments", ["character_proxy_id"], :name => "index_comments_on_character_proxy_id"
  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["community_id"], :name => "index_comments_on_community_id"
  add_index "comments", ["user_profile_id"], :name => "index_comments_on_user_profile_id"

  create_table "communities", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.string   "slogan"
    t.string   "label"
    t.boolean  "accepting",                     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_role_id"
    t.integer  "applicant_role_id"
    t.integer  "member_role_id"
    t.integer  "community_application_form_id"
    t.boolean  "email_notice_on_applicant",     :default => true
  end

  add_index "communities", ["admin_role_id"], :name => "index_communities_on_admin_role_id"
  add_index "communities", ["applicant_role_id"], :name => "index_communities_on_applicant_role_id"
  add_index "communities", ["community_application_form_id"], :name => "index_communities_on_community_application_form_id"
  add_index "communities", ["member_role_id"], :name => "index_communities_on_member_role_id"

  create_table "discussion_spaces", :force => true do |t|
    t.string   "name"
    t.boolean  "system"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_profile_id"
    t.integer  "game_id"
    t.boolean  "announcement_space"
    t.boolean  "registration_application_space"
    t.boolean  "user_profile_space"
    t.boolean  "personal_space"
    t.integer  "community_id"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "game_id"
    t.boolean  "comments_enabled",    :default => true
    t.boolean  "has_been_locked",     :default => false
  end

  add_index "discussions", ["character_proxy_id"], :name => "index_discussions_on_character_proxy_id"
  add_index "discussions", ["discussion_space_id"], :name => "index_discussions_on_discussion_space_id"
  add_index "discussions", ["game_id"], :name => "index_discussions_on_game_id"
  add_index "discussions", ["user_profile_id"], :name => "index_discussions_on_user_profile_id"

  create_table "folders", :force => true do |t|
    t.integer  "user_profile_id"
    t.integer  "parent_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "folders", ["parent_id"], :name => "index_folders_on_parent_id"
  add_index "folders", ["user_profile_id"], :name => "index_folders_on_user_profile_id"

  create_table "games", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.boolean  "is_active",                     :default => true
    t.integer  "announcement_space_id"
    t.integer  "character_discussion_space_id"
  end

  add_index "games", ["announcement_space_id"], :name => "index_games_on_announcement_space_id"
  add_index "games", ["character_discussion_space_id"], :name => "index_games_on_character_discussion_space_id"

  create_table "message_copies", :force => true do |t|
    t.integer  "recipient_id"
    t.integer  "message_id"
    t.integer  "folder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted",      :default => false
  end

  add_index "message_copies", ["folder_id"], :name => "index_message_copies_on_folder_id"
  add_index "message_copies", ["message_id"], :name => "index_message_copies_on_message_id"
  add_index "message_copies", ["recipient_id"], :name => "index_message_copies_on_recipient_id"

  create_table "messages", :force => true do |t|
    t.integer  "author_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["author_id"], :name => "index_messages_on_author_id"

  create_table "page_spaces", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "game_id"
    t.integer  "community_id"
  end

  add_index "page_spaces", ["community_id"], :name => "index_page_spaces_on_community_id"
  add_index "page_spaces", ["game_id"], :name => "index_page_spaces_on_game_id"

  create_table "pages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "body"
    t.integer  "page_space_id"
    t.boolean  "featured_page", :default => false
  end

  add_index "pages", ["page_space_id"], :name => "index_pages_on_page_space_id"

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "permissionable_id"
    t.string   "permissionable_type"
    t.string   "access"
    t.boolean  "show_p",              :default => true
    t.boolean  "create_p",            :default => false
    t.boolean  "update_p",            :default => false
    t.boolean  "delete_p",            :default => false
  end

  add_index "permissions", ["permissionable_id", "permissionable_type"], :name => "index_permissions_on_permissionable_id_and_permissionable_type"
  add_index "permissions", ["role_id"], :name => "index_permissions_on_role_id"

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "user_profile_id"
    t.integer  "discussion_id"
    t.integer  "personal_discussion_space_id"
    t.integer  "default_character_proxy_id"
    t.boolean  "is_system_profile"
    t.string   "avatar"
  end

  add_index "profiles", ["default_character_proxy_id"], :name => "index_profiles_on_default_character_proxy_id"
  add_index "profiles", ["discussion_id"], :name => "index_profiles_on_discussion_id"
  add_index "profiles", ["game_id"], :name => "index_profiles_on_game_id"
  add_index "profiles", ["personal_discussion_space_id"], :name => "index_profiles_on_personal_discussion_space_id"
  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"
  add_index "profiles", ["user_profile_id"], :name => "index_profiles_on_user_profile_id"

  create_table "questions", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_form_id"
    t.string   "type"
  end

  add_index "questions", ["site_form_id"], :name => "index_questions_on_site_form_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "community_id"
    t.string   "description"
  end

  add_index "roles", ["community_id"], :name => "index_roles_on_community_id"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "site_forms", :force => true do |t|
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "thankyou"
    t.boolean  "published",    :default => false
    t.integer  "community_id"
  end

  add_index "site_forms", ["community_id"], :name => "index_site_forms_on_community_id"

  create_table "submissions", :force => true do |t|
    t.integer  "user_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_form_id"
    t.string   "type"
    t.integer  "status"
  end

  add_index "submissions", ["site_form_id"], :name => "index_submissions_on_site_form_id"
  add_index "submissions", ["user_profile_id"], :name => "index_submissions_on_user_profile_id"

  create_table "supported_games", :force => true do |t|
    t.integer  "community_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "supported_games", ["community_id"], :name => "index_supported_games_on_community_id"
  add_index "supported_games", ["game_id"], :name => "index_supported_games_on_game_id"

  create_table "swtor_characters", :force => true do |t|
    t.string   "name"
    t.string   "server"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.integer  "discussion_id"
    t.string   "avatar"
  end

  add_index "swtor_characters", ["discussion_id"], :name => "index_swtor_characters_on_discussion_id"
  add_index "swtor_characters", ["game_id"], :name => "index_swtor_characters_on_game_id"

  create_table "system_resources", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lowercase_email"
  end

  create_table "wow_characters", :force => true do |t|
    t.string   "name"
    t.string   "faction"
    t.string   "race"
    t.integer  "level"
    t.string   "server"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.integer  "discussion_id"
    t.string   "avatar"
  end

  add_index "wow_characters", ["discussion_id"], :name => "index_wow_characters_on_discussion_id"
  add_index "wow_characters", ["game_id"], :name => "index_wow_characters_on_game_id"

end

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

ActiveRecord::Schema.define(:version => 20110713215846) do

  create_table "acknowledgment_of_announcements", :force => true do |t|
    t.integer  "announcement_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "acknowledged"
  end

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "submission_id"
  end

  create_table "character_proxies", :force => true do |t|
    t.integer  "game_profile_id"
    t.integer  "character_id"
    t.string   "character_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "character_proxy_id"
    t.integer  "user_profile_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_been_deleted"
    t.boolean  "has_been_edited"
    t.boolean  "has_been_locked"
  end

  create_table "communities", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.string   "slogan"
    t.string   "label"
    t.boolean  "accepting"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_role_id"
    t.integer  "applicant_role_id"
    t.integer  "member_role_id"
    t.integer  "community_application_form_id"
    t.boolean  "email_notice_on_applicant"
  end

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
    t.boolean  "has_been_locked"
  end

  create_table "folders", :force => true do |t|
    t.integer  "user_profile_id"
    t.integer  "parent_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.boolean  "is_active"
    t.integer  "announcement_space_id"
    t.integer  "character_discussion_space_id"
  end

  create_table "message_copies", :force => true do |t|
    t.integer  "recipient_id"
    t.integer  "message_id"
    t.integer  "folder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted"
  end

  create_table "messages", :force => true do |t|
    t.integer  "author_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "site_form_id"
    t.integer  "user_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_spaces", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "game_id"
    t.integer  "community_id"
  end

  create_table "pages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "body"
    t.integer  "page_space_id"
    t.boolean  "featured_page"
  end

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "permissionable_id"
    t.string   "permissionable_type"
    t.string   "access"
    t.boolean  "show_p"
    t.boolean  "create_p"
    t.boolean  "update_p"
    t.boolean  "delete_p"
  end

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

  create_table "questions", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_form_id"
    t.string   "type"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "community_id"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.boolean  "published"
    t.integer  "community_id"
  end

  create_table "submissions", :force => true do |t|
    t.integer  "user_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "discussion_id"
    t.integer  "site_form_id"
    t.string   "type"
    t.integer  "status"
  end

  create_table "supported_games", :force => true do |t|
    t.integer  "community_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "swtor_characters", :force => true do |t|
    t.string   "name"
    t.string   "server"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.integer  "discussion_id"
  end

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
  end

end

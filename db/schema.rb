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

ActiveRecord::Schema.define(:version => 20110205231654) do

  create_table "acknowledgment_of_announcements", :force => true do |t|
    t.integer  "announcement_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "acknowledged"
  end

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.integer  "registration_application_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "characters", :force => true do |t|
    t.integer  "game_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "faction"
    t.string   "race"
    t.string   "klass"
    t.string   "server"
    t.string   "extra"
    t.integer  "rank"
    t.integer  "game_profile_id"
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "character_id"
    t.integer  "user_profile_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_been_deleted"
    t.boolean  "has_been_edited"
    t.boolean  "has_been_locked"
  end

  create_table "discussion_spaces", :force => true do |t|
    t.string   "name"
    t.boolean  "system"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_profile_id"
    t.integer  "game_id"
    t.boolean  "announcement_space"
  end

  create_table "discussions", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "discussion_space_id"
    t.integer  "character_id"
    t.integer  "user_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "game_id"
    t.boolean  "comments_enabled",    :default => true
  end

  create_table "donations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "extra"
    t.boolean  "is_active"
    t.integer  "announcement_space_id"
  end

  create_table "letters", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletters", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_spaces", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "pages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "body"
    t.integer  "page_space_id"
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
    t.integer  "default_character_id"
  end

  create_table "questions", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "answers"
    t.integer  "site_form_id"
    t.string   "type"
  end

  create_table "registration_applications", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_profile_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "system_resources", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teamspeaks", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active"
    t.boolean  "is_applicant"
  end

end

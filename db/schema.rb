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

ActiveRecord::Schema.define(:version => 20110905184110) do

  create_table "communities", :force => true do |t|
    t.string   "name"
    t.string   "slogan"
    t.string   "label"
    t.boolean  "accepting_members",           :default => true
    t.boolean  "email_notice_on_application", :default => true
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_profile_id"
    t.integer  "member_role_id"
  end

  add_index "communities", ["admin_profile_id"], :name => "index_communities_on_admin_profile_id"
  add_index "communities", ["member_role_id"], :name => "index_communities_on_member_role_id"

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

  create_table "roles", :force => true do |t|
    t.integer  "community_id"
    t.string   "name"
    t.boolean  "system_generated", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["community_id"], :name => "index_roles_on_community_id"

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
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

end

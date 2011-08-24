class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    add_index :acknowledgment_of_announcements, :announcement_id
    add_index :acknowledgment_of_announcements, :profile_id

    add_index :announcements, :user_profile_id
    add_index :announcements, :community_id
    add_index :announcements, :game_id

    add_index :answers, :question_id
    add_index :answers, :submission_id

    add_index :character_proxies, :game_profile_id
    add_index :character_proxies, [:character_id, :character_type]

    add_index :comments, :character_proxy_id
    add_index :comments, :user_profile_id
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, :community_id

    add_index :communities, :admin_role_id
    add_index :communities, :applicant_role_id
    add_index :communities, :member_role_id
    add_index :communities, :community_application_form_id

    add_index :discussion_spaces, :user_profile_id
    add_index :discussion_spaces, :game_id
    add_index :discussion_spaces, :community_id

    add_index :discussions, :discussion_space_id
    add_index :discussions, :character_proxy_id
    add_index :discussions, :user_profile_id
    add_index :discussions, :game_id

    add_index :folders, :user_profile_id
    add_index :folders, :parent_id

    add_index :games, :announcement_space_id
    add_index :games, :character_discussion_space_id

    add_index :message_copies, :recipient_id
    add_index :message_copies, :message_id
    add_index :message_copies, :folder_id

    add_index :messages, :author_id

    add_index :page_spaces, :game_id
    add_index :page_spaces, :community_id

    add_index :pages, :page_space_id

    add_index :permissions, [:permissionable_id, :permissionable_type]
    add_index :permissions, :role_id

    add_index :profiles, :user_id
    add_index :profiles, :game_id
    add_index :profiles, :user_profile_id
    add_index :profiles, :discussion_id
    add_index :profiles, :personal_discussion_space_id
    add_index :profiles, :default_character_proxy_id

    add_index :questions, :site_form_id

    add_index :roles, :community_id

    add_index :roles_users, :role_id
    add_index :roles_users, :user_id

    add_index :site_forms, :community_id

    add_index :submissions, :user_profile_id
    add_index :submissions, :site_form_id

    add_index :supported_games, :community_id
    add_index :supported_games, :game_id

    add_index :swtor_characters, :game_id
    add_index :swtor_characters, :discussion_id

    add_index :wow_characters, :game_id
    add_index :wow_characters, :discussion_id
  end

  def self.down
    remove_index :acknowledgment_of_announcements, :announcement_id
    remove_index :acknowledgment_of_announcements, :profile_id

    remove_index :announcements, :user_profile_id
    remove_index :announcements, :community_id
    remove_index :announcements, :game_id

    remove_index :answers, :question_id
    remove_index :answers, :submission_id

    remove_index :character_proxies, :game_profile_id
    remove_index :character_proxies, [:character_id, :character_type]

    remove_index :comments, :character_proxy_id
    remove_index :comments, :user_profile_id
    remove_index :comments, [:commentable_id, :commentable_type]
    remove_index :comments, :community_id

    remove_index :communities, :admin_role_id
    remove_index :communities, :applicant_role_id
    remove_index :communities, :member_role_id
    remove_index :communities, :community_application_form_id

    remove_index :discussion_spaces, :user_profile_id
    remove_index :discussion_spaces, :game_id
    remove_index :discussion_spaces, :community_id

    remove_index :discussions, :discussion_space_id
    remove_index :discussions, :character_proxy_id
    remove_index :discussions, :user_profile_id
    remove_index :discussions, :game_id

    remove_index :folders, :user_profile_id
    remove_index :folders, :parent_id

    remove_index :games, :announcement_space_id
    remove_index :games, :character_discussion_space_id

    remove_index :message_copies, :recipient_id
    remove_index :message_copies, :message_id
    remove_index :message_copies, :folder_id

    remove_index :messages, :author_id

    remove_index :page_spaces, :game_id
    remove_index :page_spaces, :community_id

    remove_index :pages, :page_space_id

    remove_index :permissions, [:permissionable_id, :permissionable_type]
    remove_index :permissions, :role_id

    remove_index :profiles, :user_id
    remove_index :profiles, :game_id
    remove_index :profiles, :user_profile_id
    remove_index :profiles, :discussion_id
    remove_index :profiles, :personal_discussion_space_id
    remove_index :profiles, :default_character_proxy_id

    remove_index :questions, :site_form_id

    remove_index :roles, :community_id

    remove_index :roles_users, :role_id
    remove_index :roles_users, :user_id

    remove_index :site_forms, :community_id

    remove_index :submissions, :user_profile_id
    remove_index :submissions, :site_form_id

    remove_index :supported_games, :community_id
    remove_index :supported_games, :game_id

    remove_index :swtor_characters, :game_id
    remove_index :swtor_characters, :discussion_id

    remove_index :wow_characters, :game_id
    remove_index :wow_characters, :discussion_id
  end
end

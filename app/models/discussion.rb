=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents a discussion.
=end
class Discussion < ActiveRecord::Base
  #attr_accessible :name, :body, :comments_enabled, :has_been_locked
  #attr_accessible :user_profile, :character_proxy, :discussion_space, :comments, :game

  belongs_to :user_profile
  belongs_to :character_proxy
  belongs_to :discussion_space
  belongs_to :game
  has_many :comments, :as => :commentable
  has_one :community, :through => :discussion_space

  before_create :use_default_character

=begin
  _before_create_

  This method attempts to use the default character if this discussion is in a game discussion space.
  [Returns] False if the operation could not be preformed, otherwise true.
=end
  def use_default_character
    return unless self.user_profile and self.respond_to?('game') and self.discussion_space and self.discussion_space.game
    self.user_profile.game_profiles.each do |game_profile|
      if(game_profile.game.id == self.discussion_space.game.id)
        self.character_proxy_id = game_profile.default_character_proxy_id
      end
    end
  end

=begin
  This method gets display name of the user profile if the user profile was used to post.
  [Returns] A string that contains the display_name of the user profile if the user profile exists, otherwise nil.
=end
  def users_name
    return user_profile.display_name if user_profile
    nil
  end

=begin
  This method gets character related to this discussion if a character was used to post.
  [Returns] The character that posted if it exists, otherwise nil.
=end
  def character
    return character_proxy.character if character_proxy
    nil
  end

=begin
  This method gets the display name of the character related to this discussion if a character was used to post.
  [Returns] The diplay name of the character that posted if it exists, otherwise nil.
=end
  def characters_name
    return character.display_name if self.charater_posted?
    nil
  end

=begin
  This method determines if a character created this discussion.
  [Returns] True if a character created this discussion, otherwise nil.
=end
  def charater_posted?
    character != nil
  end

=begin
  This method determines how many comments have been made regarding this discussion.
  [Returns] An integer that contains how many comments have been made for this discussion, including comments on a comment (recursivly).
=end
  def number_of_comments
   temp_total_num_comments = 0
   comments.each do |comment|
     temp_total_num_comments += comment.number_of_comments
   end
   temp_total_num_comments
  end

=begin
  This method defines how show permissions are determined for this discussion.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this discussion, otherwise false.
=end
  def check_user_show_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_show(DiscussionSpace.find(self.discussion_space.id)) or user.can_show("Discussion")
  end

=begin
  This method defines how create permissions are determined for this discussion.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this discussion, otherwise false.
=end
  def check_user_create_permissions(user)
    if(self.discussion_space)
      return user.can_create(DiscussionSpace.find(self.discussion_space.id))
    end
    user.can_create("Discussion")
  end

=begin
  This method defines how update permissions are determined for this discussion.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this discussion, otherwise false.
=end
  def check_user_update_permissions(user)
    if has_been_locked
      return false
    end
    if user.user_profile == self.user_profile
      return true
    end
    user.can_update(DiscussionSpace.find(self.discussion_space.id)) or user.can_update("Discussion")
  end

=begin
  This method defines how delete permissions are determined for this discussion.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can delete this discussion, otherwise false.
=end
  def check_user_delete_permissions(user)
    if has_been_locked
      return false
    end
    if user.user_profile == self.user_profile
      return true
    end
    #Hack
    user.can_delete(DiscussionSpace.find(self.discussion_space.id)) or user.can_delete("Discussion")
  end

=begin
  This method defines how locking permissions are determined for this discussion.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can lock this discussion, otherwise false.
=end
  def can_user_lock(user)
    return true if user and user.user_profile == self.discussion_space.user_profile
    user.can_special_permissions("Discussion","lock")
  end
end


# == Schema Information
#
# Table name: discussions
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  body                :text
#  discussion_space_id :integer
#  character_proxy_id  :integer
#  user_profile_id     :integer
#  created_at          :datetime
#  updated_at          :datetime
#  type                :string(255)
#  game_id             :integer
#  comments_enabled    :boolean         default(TRUE)
#  has_been_locked     :boolean         default(FALSE)
#


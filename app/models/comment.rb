=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents a comment.
=end
class Comment < ActiveRecord::Base

=begin
  This attribute is for javascript to let a comment know what dom element is the target for the comment form after a comment has been submitted.
=end
  attr_accessor :form_target

=begin
  This attribute is for javascript to let a comment know what dom element is the target for the comment when it created.
=end
  attr_accessor :comment_target
  #attr_accessible :commentable, :character_proxy, :user_profile, :community, :comments
  #attr_accessible :has_been_deleted, :has_been_edited, :has_been_locked

  belongs_to :commentable, :polymorphic => true
  belongs_to :character_proxy
  belongs_to :user_profile
  belongs_to :community
  has_many :comments, :as => :commentable

  before_create :use_default_character, :get_community_id_from_source

=begin
  This method gets the character_proxy id for the character who made this comment, if possible.
  [Returns] The id of the character_proxy that made the comment, otherwise nil.
=end
  def character_proxy_id
    return self.character_proxy.id if self.character_proxy
    nil
  end

=begin
  _before_create_

  This method will attempt to use the default character for the game that the comment is attached to, if possible.
  This will not happen if the character_proxy is already set.
  [Returns] False if an error was encountered, otherwise true.
=end
  def use_default_character
    return if self.character_proxy or not(self.user_profile)
    if(self.original_comment_item.respond_to?('game'))
      self.user_profile.game_profiles.each do |game_profile|
        if(game_profile.game == original_comment_item.game)
          self.character_proxy_id = game_profile.default_character_proxy_id
        end
      end
    end
  end

=begin
  _before_create_

  This method will get and use the community of the item that this comment is attached to, if possible.
  [Returns] False if an error was encountered, otherwise true.
=end
  def get_community_id_from_source
    return if self.community
    if self.commentable.respond_to?('community')
      self.community = self.commentable.community
    end
    if self.original_comment_item.respond_to?('community')
      self.community = self.original_comment_item.community
    end
  end

=begin
  This method gets name of the user who made this comment, if possible.
  [Returns] The name of the user made this comment, otherwise nil.
=end
  def users_name
    return self.user_profile.display_name if self.user_profile
    nil
  end

=begin
  This method gets name of the character who made this comment, if possible.
  [Returns] The name of the character made this comment, otherwise nil.
=end
  def characters_name
    return self.character_proxy.character.name if self.character_proxy
    nil
  end

=begin
  This method gets character who made this comment, if possible.
  [Returns] The character that made this comment, otherwise nil.
=end
  def character
    return self.character_proxy.character if character_proxy
    nil
  end

=begin
  This method checks to see if a character posted this comment
  [Returns] True if a character made this comment, otherwise false.
=end
  def charater_posted?
    character_proxy != nil
  end

=begin
  This method returns the total number of comments that this comment has, including itself.
  [Returns] An integer that contains the number of comments this comment has including itself.
=end
  def number_of_comments
   temp_total_num_comments = 1
   comments.each do |comment|
     temp_total_num_comments += comment.number_of_comments
   end
   temp_total_num_comments
  end

=begin
  This method returns an array of HTML classes that should be be applied to this comment.
  [Returns] An array of HTML classes.
=end
  def html_classes
    html_classes = Array.new()
    html_classes << 'locked' if has_been_locked
    html_classes << 'edited' if has_been_edited
    #html_classes << 'deleted' if has_been_deleted
    #html_classes << 'op' if is_by_op
    html_classes
  end

=begin
  This method returns the original item that this comment is attached to, climbing the comment tree if needed.
  [Returns] The original comment item.
=end
  def original_comment_item
    (commentable.respond_to?('original_comment_item')) ? commentable.original_comment_item : commentable
  end

=begin
  This method checks to see if replys to this comment are allowed.
  [Returns] True if replys are allowed for this comment, otherwise false.
=end
  def replys_locked?
    self.has_been_locked or !self.original_comment_item.comments_enabled? or (self.original_comment_item.respond_to?('has_been_locked') and self.original_comment_item.has_been_locked)
  end

=begin
  This method defines how show permissions are determined for this comment.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this comment, otherwise false.
=end
  def check_user_show_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
  end

=begin
  This method defines how create permissions are determined for this comment.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this comment, otherwise false.
=end
  def check_user_create_permissions(user)
    if self.commentable.respond_to?('has_been_locked') and self.commentable.has_been_locked
      return false
    end
    if user.user_profile == self.user_profile
      return true
    end
    user.can_show(original_comment_item) or user.can_create("Comment")
  end

=begin
  This method defines how update permissions are determined for this comment.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this comment, otherwise false.
=end
  def check_user_update_permissions(user)
    if self.has_been_locked or self.replys_locked?
      return false
    end
    if user.user_profile == self.user_profile
      return true
    end
    false
  end

=begin
  This method defines how delete permissions are determined for this comment.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can delete this comment, otherwise false.
=end
  def check_user_delete_permissions(user)
    if self.has_been_locked or self.replys_locked? or self.has_been_deleted
      return false
    end
    if user.user_profile == self.user_profile
      return true
    end
    user.can_delete(original_comment_item) or user.can_delete("Comment")
  end

=begin
  This method defines how lock permissions are determined for this comment.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can lock this comment, otherwise false.
=end
  def can_user_lock(user)
    user.can_special_permissions("Comment","lock")
  end

  # The commentable_type always needs to be of the base class type and not the subclass type.
  def commentable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end

end


# == Schema Information
#
# Table name: comments
#
#  id                 :integer         not null, primary key
#  body               :text
#  character_proxy_id :integer
#  user_profile_id    :integer
#  commentable_id     :integer
#  commentable_type   :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  has_been_deleted   :boolean         default(FALSE)
#  has_been_edited    :boolean         default(FALSE)
#  has_been_locked    :boolean         default(FALSE)
#  community_id       :integer
#


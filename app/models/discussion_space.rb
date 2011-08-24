=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents a discussion space.
=end
class DiscussionSpace < ActiveRecord::Base
  #attr_accessible :name, :system, :announcement_space, :registration_application_space, :user_profile_space,
  #  :community, :game, :user_profile, :discussions

  belongs_to :user_profile
  belongs_to :game
  belongs_to :community
  has_many :discussions

  validate :only_one_announcement_space, :has_a_user_profile,
           :only_one_user_profile_space

  scope :user_generated, where(:system => false)
  scope :system_generated, where(:system => true)

  def self.only_real_ones
    self.where{(system == false) | (announcement_space != true)}
  end

=begin
  This method gets the name of the game this discussion space belongs to.
  [Returns] The game that this discussion space belongs to, otherwise nil.
=end
  def game_name
    self.game.name if self.game
  end

  def only_one_announcement_space
    errors.add(:id, "There can be only one!  ...announcement space.") if (DiscussionSpace.site_announcement_space.exists? and self.announcement_space and self.game_id = nil)
  end

  def self.site_announcement_space
    DiscussionSpace.where(:announcement_space => true, :game_id => nil)
  end

  def has_a_user_profile
    errors.add(:id, "Internal rails error, no user found to create a discussion space.") if (!user_profile and !system)
  end

  def only_one_user_profile_space
    errors.add(:id, "There can be only one!  ...user profile space.") if (DiscussionSpace.where(:user_profile_space => true).exists? and self.user_profile_space)
  end

# TODO This needs to be evaluated
  def self.user_profile_space
    if DiscussionSpace.where(:user_profile_space => true).exists?
      return DiscussionSpace.where(:user_profile_space => true).first
    else
      return DiscussionSpace.create(:name => "User Profiles ", :system => true, :user_profile_space => true)
    end
  end

=begin
  This method gets the user profile name of the creator of this discussion space
  [Returns] The display name of the user profile that created this discussion space, otherwise nil.
=end
  def user_profile_name
    return user_profile.display_name if user_profile
    nil
  end

# TODO This needs to be evaluated
  def list_in_navigation
    !self.personal_space
  end

=begin
  This method defines how show permissions are determined for this discussion space.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this discussion space, otherwise false.
=end
  def check_user_show_permissions(user)
    return true if user_profile_space and user
    return true if self.game and self.game.character_discussion_space_id = self.id and user
    return true if user and user.user_profile == self.user_profile
    return self.announcement_space if self.announcement_space and user
    user.can_show("DiscussionSpace") if user
  end

=begin
  This method defines how create permissions are determined for this discussion space.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this discussion space, otherwise false.
=end
  def check_user_create_permissions(user)
    return true if user and user.user_profile == self.user_profile
    user.can_create("DiscussionSpace")
  end

=begin
  This method defines how update permissions are determined for this discussion space.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this discussion space, otherwise false.
=end
  def check_user_update_permissions(user)
    return true if user and user.user_profile == self.user_profile
    user.can_update("DiscussionSpace") and not self.system
  end

=begin
  This method defines how delete permissions are determined for this discussion space.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can delete this discussion space, otherwise false.
=end
  def check_user_delete_permissions(user)
    return true if user and user.user_profile == self.user_profile
    user.can_delete("DiscussionSpace") and not self.system
  end
end

# == Schema Information
#
# Table name: discussion_spaces
#
#  id                             :integer         not null, primary key
#  name                           :string(255)
#  system                         :boolean
#  created_at                     :datetime
#  updated_at                     :datetime
#  user_profile_id                :integer
#  game_id                        :integer
#  announcement_space             :boolean
#  registration_application_space :boolean
#  user_profile_space             :boolean
#  personal_space                 :boolean
#  community_id                   :integer
#


=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a game announcement.
=end
class GameAnnouncement < CommunityAnnouncement
  #attr_accessible :name, :body, :user_profile, :game_profiles, :community, :game
  
  belongs_to :game
  has_many :game_profiles, :through => :acknowledgment_of_announcements
  belongs_to :user_profile
  
  after_create :create_acknowledgments
  
  validate :name, :presence => true
  validate :body, :presence => true
  validate :user_profile, :presence => true
  validate :community, :presence => true
  validate :game, :presence => true
  
=begin
  _after_create_
  
  This method creates all of the acknowledgments for this announcement.
  [Returns] False if the operation could not be preformed, otherwise true.
=end
  def create_acknowledgments
    user_profiles = Array.new
    self.community.all_users.each do |user| 
      user_profiles << user.user_profile
    end
    
    for profile in user_profiles
      game_profile = profile.game_profiles.find(:first, :conditions => {:game_id => self.game.id})
        if game_profile != nil
          AcknowledgmentOfAnnouncement.create(:announcement_id => self.id, :profile_id => game_profile.id, :acknowledged => false)
        end
    end
  end

=begin
  This method defines how show permissions are determined for this game announcement.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this game announcement, otherwise false.
=end
  def check_user_show_permissions(user)
    user.all_game_profiles.each do |gameprofile|
      if game.id == gameprofile.game_id
        return true
      end
    end
    user.can_show("GameAnnouncement") or user.can_show("SiteAnnouncement") 
  end
  
=begin
  This method defines how create permissions are determined for this game announcement.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this game announcement, otherwise false.
=end
  def check_user_create_permissions(user)
    user.can_create("GameAnnouncement") or user.can_create("SiteAnnouncement")
  end
  
=begin
  This method defines how update permissions are determined for this game announcement.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this game announcement, otherwise false.
=end
  def check_user_update_permissions(user)
    user.can_update("GameAnnouncement") or user.can_update("SiteAnnouncement")
  end
  
=begin
  This method defines how delete permissions are determined for this game announcement.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this game announcement, otherwise false.
=end
  def check_user_delete_permissions(user)
    user.can_delete("GameAnnouncement") or user.can_delete("SiteAnnouncement")
  end
end

# == Schema Information
#
# Table name: announcements
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  body             :text
#  user_profile_id  :integer
#  game_id          :integer
#  community_id     :integer
#  type             :string(255)
#  comments_enabled :boolean         default(TRUE)
#  created_at       :datetime
#  updated_at       :datetime
#


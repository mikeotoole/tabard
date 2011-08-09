=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a site wide announcement.
=end
class SiteAnnouncement < Announcement
  #attr_accessible :name, :body, :user_profiles, :community
  
  has_many :user_profiles, :through => :acknowledgment_of_announcements
  
  after_create :create_acknowledgments
  
  validate :name, :presence => true
  validate :body, :presence => true
  
  def create_acknowledgments
    @userprofiles = UserProfile.all
    
    for profile in @userprofiles     
      AcknowledgmentOfAnnouncement.create(:announcement_id => self.id, :profile_id => profile.id, :acknowledged => false)
    end
  end
    
=begin
  This method defines how show permissions are determined for this site announcement.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this site announcement, otherwise false.
=end
  def check_user_show_permissions(user)
    true
  end
  
=begin
  This method defines how create permissions are determined for this site announcement.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this site announcement, otherwise false.
=end
  def check_user_create_permissions(user)
    false
  end
  
=begin
  This method defines how update permissions are determined for this site announcement.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this site announcement, otherwise false.
=end
  def check_user_update_permissions(user)
    false
  end
  
=begin
  This method defines how delete permissions are determined for this site announcement.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can delete this site announcement, otherwise false.
=end
  def check_user_delete_permissions(user)
    false
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


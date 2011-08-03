=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a community announcement.
=end
class CommunityAnnouncement < Announcement
  #attr_accessible :name, :body
  
  validate :name, :presence => true
  validate :body, :presence => true
  validate :user_profile, :presence => true
  validate :community, :presence => true
  
  belongs_to :community
  belongs_to :user_profile
  
  has_many :user_profiles, :through => :acknowledgment_of_announcements
  
  after_create :create_acknowledgments

=begin
  _after_create_
  
  This method creates the acknowledgments required for this announcement.
  [Returns] False if the operation could not be preformed, otherwise true.
=end  
  def create_acknowledgments
    self.community.all_users.each do |user| 
      AcknowledgmentOfAnnouncement.create(:announcement_id => self.id, :profile_id => user.user_profile.id, :acknowledged => false)
    end
  end

=begin
  This method defines how show permissions are determined for this community announcement.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True the provided user can show this community announcement, otherwise false.
=end 
  def check_user_show_permissions(user)
    true
  end
  
=begin
  This method defines how create permissions are determined for this community announcement.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True the provided user can create this community announcement, otherwise false.
=end
  def check_user_create_permissions(user)
    false
  end
  
=begin
  This method defines how update permissions are determined for this community announcement.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True the provided user can update this community announcement, otherwise false.
=end
  def check_user_update_permissions(user)
    false
  end

=begin
  This method defines how delete permissions are determined for this community announcement.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True the provided user can delete this community announcement, otherwise false.
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


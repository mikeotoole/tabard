=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a site form.
=end
class SiteForm < ActiveRecord::Base
  #attr_accessible :message, :name, :thank_you, :published, :community, :questions, :submissions
  
  has_many :questions, :dependent => :destroy
  has_many :submissions, :dependent => :destroy
  
  scope :published, :conditions => {:published => true, :registration_application_form => false}
  
  belongs_to :community
  
=begin
  This method gets the name of the community that this form belongs to.
  [Returns] A string that contains the display name of the community that this form belongs to, otherwise it contains the empty string.
=end
  def community_name
    return self.community.display_name if self.community
    ""
  end
  
=begin
  This method defines how show permissions are determined for this site form.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this site form, otherwise false.
=end
  def check_user_show_permissions(user)
    return true if self.published
    user.can_show("SiteForm")
  end
  
=begin
  This method defines how create permissions are determined for this site form.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this site form, otherwise false.
=end
  def check_user_create_permissions(user)
    user.can_create("SiteForm")
  end
  
=begin
  This method defines how update permissions are determined for this site form.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this site form, otherwise false.
=end
  def check_user_update_permissions(user)
    user.can_update("SiteForm")
  end
  
=begin
  This method defines how delete permissions are determined for this site form.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can delete this site form, otherwise false.
=end
  def check_user_delete_permissions(user)
    user.can_delete("SiteForm")
  end
end

# == Schema Information
#
# Table name: site_forms
#
#  id           :integer         not null, primary key
#  message      :text
#  created_at   :datetime
#  updated_at   :datetime
#  name         :string(255)
#  thankyou     :string(255)
#  published    :boolean
#  community_id :integer
#


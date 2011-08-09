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
  
  belongs_to :community
  
  def community_name
    self.community.display_name if self.community
  end
  
  def self.application_form
    SiteForm.find(:first, :conditions => { :registration_application_form => true })
  end
  
  def self.published
    SiteForm.find(:all, :conditions => { :published => true, :registration_application_form => false })
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


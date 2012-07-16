###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is the support comment class.
###
class SupportComment < ActiveRecord::Base
###
# Associations
###
  belongs_to :support_ticket, inverse_of: :support_comments
  belongs_to :admin_user, inverse_of: :support_comments
  belongs_to :user_profile, inverse_of: :support_comments

###
# Attribute accessible
###
  attr_accessible :body

###
# Delegates
###
  delegate :user_profile_id, to: :support_ticket, prefix: true
  delegate :admin_user_display_name, to: :support_ticket, prefix: true
  delegate :admin_user_email, to: :support_ticket, prefix: true
  delegate :id, to: :support_ticket, prefix: true

  delegate :display_name, to: :admin_user, prefix: true
  delegate :email, to: :admin_user, prefix: true

  delegate :full_name, to: :user_profile, prefix: true

###
# Validators
###
  validate :only_admin_or_user
  validates :user_profile, presence: true, if: "admin_user_id.blank?"
  validates :admin_user, presence: true, if: "user_profile_id.blank?"
  validates :body, presence: true

  # This method validates that only an admin or an user is the creater, not both.
  def only_admin_or_user
    self.errors.add(:base, "Only a user_profile or admin_user may be associated, not both") unless self.admin_user_id.blank? or self.user_profile_id.blank?
  end

  # Returns true if an admin created this.
  def admin_created?
    return (not self.admin_user.blank?)
  end
  # Returns true if an user created this.
  def user_created?
    return (not self.user_profile.blank?)
  end

  # Returns the correct name
  def author_name
    return self.user_profile_full_name if user_created?
    return self.admin_user_display_name if admin_created?
    "Anonymous"
  end

  # Returns the correct avatar
  def avatar(options)
    return self.user_profile_avatar_url(options) if user_created?
    return self.admin_user_avatar_url(options) if admin_created?
    nil
  end

end

# == Schema Information
#
# Table name: support_comments
#
#  id                :integer         not null, primary key
#  support_ticket_id :integer
#  user_profile_id   :integer
#  admin_user_id     :integer
#  body              :text
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#


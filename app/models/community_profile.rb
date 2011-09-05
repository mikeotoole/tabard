###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This model represents a community profile.
###
class CommunityProfile < ActiveRecord::Base
###
# Associations
###
  # TODO Joe/Bryan We need to evaluate the eager loading of associations and inverse_of to optimize our memory footprints and speed. -JW
  belongs_to :community
  belongs_to :user_profile
  has_and_belongs_to_many :roles

###
# Validators
###
  validates :community, :presence => true
  validates :user_profile, :presence => true
  validates :user_profile_id, :uniqueness => {:scope => :community_id}
  validate :has_at_least_the_default_member_role

###
# Public Methods
###
  def has_at_least_the_default_member_role
    true # TODO Joe Add this complex validator -JW
  end

end


# == Schema Information
#
# Table name: community_profiles
#
#  id              :integer         not null, primary key
#  community_id    :integer
#  user_profile_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#


###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an actvity.
###
class Activity < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :target_type, :target_id, :action

###
# Associations
###
  belongs_to :user_profile
  belongs_to :community
  belongs_to :target

###
# Validators
###
  validates :target, :presence => true

end

# == Schema Information
#
# Table name: activities
#
#  id              :integer         not null, primary key
#  user_profile_id :integer
#  community_id    :integer
#  target_type     :string(255)
#  target_id       :integer
#  action          :string(255)
#  deleted_at      :datetime
#  created_at      :datetime
#


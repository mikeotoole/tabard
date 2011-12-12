###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This model represents a role.
###
class Role < ActiveRecord::Base
###
# Associations
###
  belongs_to :community
  has_many :permissions
  has_and_belongs_to_many :community_profiles

###
# Validators
###
  validates :community, :presence => true
  validates :name,  :uniqueness => {:scope => :community_id},
                    :length => { :maximum => 100 }

###
# Delegates
###
  delegate :admin_profile_id, :to => :community, :prefix => true

end




# == Schema Information
#
# Table name: roles
#
#  id                  :integer         not null, primary key
#  community_id        :integer
#  name                :string(255)
#  is_system_generated :boolean         default(FALSE)
#  created_at          :datetime
#  updated_at          :datetime
#


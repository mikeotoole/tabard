###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an actvity.
###
class Acknowledgement < ActiveRecord::Base
  scope :ordered, :order => 'created_at DESC'

###
# Associations
###  
  belongs_to :community_profile
  belongs_to :announcement
  
###
# Delegates
###
  delegate :user_profile, :to => :community_profile, :allow_nil => true
  delegate :poster, :to => :announcement, :allow_nil => true
  delegate :display_name, :to => :poster, :prefix => true, :allow_nil => true
  delegate :community_name, :to => :community_profile, :allow_nil => true
  delegate :subdomain, :to => :announcement, :allow_nil => true
end



# == Schema Information
#
# Table name: acknowledgements
#
#  id                   :integer         not null, primary key
#  community_profile_id :integer
#  announcement_id      :integer
#  has_been_viewed      :boolean         default(FALSE)
#  created_at           :datetime
#  updated_at           :datetime
#


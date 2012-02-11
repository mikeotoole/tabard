###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an actvity.
###
class Acknowledgement < ActiveRecord::Base
  belongs_to :community_profile
  belongs_to :announcement
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


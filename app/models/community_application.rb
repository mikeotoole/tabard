class CommunityApplication < ActiveRecord::Base
###
# Constants
###
  # The list of vaild status values.
  VALID_STATUSES =  %w(Pending Accepted Rejected)

###
# Associations
###
  belongs_to :community
  belongs_to :user_profile
  belongs_to :submission

###
# Validators
###
  validates :community,  :presence => true
  validates :user_profile,  :presence => true
  validates :submission,  :presence => true
  validates :status,  :presence => true,
                    :inclusion => { :in => VALID_STATUSES, :message => "%{value} is not a valid status" }
end

# == Schema Information
#
# Table name: community_applications
#
#  id              :integer         not null, primary key
#  community_id    :integer
#  user_profile_id :integer
#  submission_id   :integer
#  status          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#


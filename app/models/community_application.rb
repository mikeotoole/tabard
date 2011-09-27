class CommunityApplication < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible
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
                    :inclusion => { :in => VALID_STATUSES, :message => "%{value} is not a valid status" },
                    :on => :update
  validate :community_and_submission_match
  validate :user_profile_and_submission_match
###
# Callbacks
###
  before_create :assign_pending_status

  ###
  # _before_create_
  #
  # This method sets the application to pending.
  ###
  def assign_pending_status
    self.status = "Pending"
  end

protected
  # This method ensures that the community application for is the custom form for the submission
  def community_and_submission_match
    return unless submission and community
    errors.add(:base, "The submission does not match the community's application form.") unless submission.custom_form == community.community_application_form
  end
  # This method ensures that the community application for is the custom form for the submission
  def user_profile_and_submission_match
    return unless submission and user_profile
    errors.add(:base, "The submission does not match this user profile.") unless submission.user_profile == user_profile
  end
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


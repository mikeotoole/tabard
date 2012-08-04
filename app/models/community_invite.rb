class CommunityInvite < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :applicant_id, :community_id, :sponsor_id
###
# Associations
###
  belongs_to :applicant, class_name: "UserProfile", inverse_of: :community_invite_applications
  belongs_to :sponsor, class_name: "UserProfile", inverse_of: :community_invite_sponsors
  belongs_to :community

###
# Validators
###
  validates :applicant_id, uniqueness: {scope: [:sponsor_id, :community_id]}
  validates :applicant, presence: true
  validates :sponsor, presence: true
  validates :community, presence: true
  validate :applicant_cant_be_the_same_as_sponsor
  validate :sponsor_must_be_member_of_community
###
# Delegates
###
  delegate :name, to: :community, prefix: true
  delegate :subdomain, to: :community, prefix: true
  delegate :display_name, to: :sponsor, prefix: true
  delegate :display_name, to: :applicant, prefix: true
###
# Validator Methods
###
  ###
  # This method validates that the applicant can't also be the sponsor.
  ###
  def applicant_cant_be_the_same_as_sponsor
    return false if sponsor.blank? or applicant.blank?
    self.errors.add(:base, "The sponsor can't be the applicant") if self.sponsor == self.applicant
  end

  ###
  # This method validates that sponsor must be in the community.
  ###
  def sponsor_must_be_member_of_community
    return false if sponsor.blank? or community.blank?
    self.errors.add(:base, "The sponsor must be a member of the community") unless self.sponsor.is_member?(self.community)
  end
end

# == Schema Information
#
# Table name: community_invites
#
#  id           :integer          not null, primary key
#  applicant_id :integer
#  sponsor_id   :integer
#  community_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


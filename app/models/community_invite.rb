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
# Delegates
###
  delegate :name, to: :community, prefix: true
  delegate :subdomain, to: :community, prefix: true
  delegate :display_name, to: :sponsor, prefix: true
  delegate :display_name, to: :applicant, prefix: true
  delegate :id, to: :applicant, prefix: true
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


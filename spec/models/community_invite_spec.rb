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

require 'spec_helper'

describe CommunityInvite do
  pending "add some examples to (or delete) #{__FILE__}"
end

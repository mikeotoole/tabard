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

require 'spec_helper'

describe CommunityApplication do
  pending "add some examples to (or delete) #{__FILE__}"
end

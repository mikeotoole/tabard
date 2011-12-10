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

require 'spec_helper'

describe Activity do
  pending "add some examples to (or delete) #{__FILE__}"
end

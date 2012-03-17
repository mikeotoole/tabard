# == Schema Information
#
# Table name: invites
#
#  id                 :integer         not null, primary key
#  event_id           :integer
#  user_profile_id    :integer
#  character_proxy_id :integer
#  status             :string(255)
#  is_viewed          :boolean         default(FALSE)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

require 'spec_helper'

describe Invite do
  pending "add some examples to (or delete) #{__FILE__}"
end

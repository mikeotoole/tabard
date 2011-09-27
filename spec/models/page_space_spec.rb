# == Schema Information
#
# Table name: page_spaces
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  user_profile_id :integer
#  game_id         :integer
#  community_id    :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe PageSpace do
  pending "add some examples to (or delete) #{__FILE__}"
end

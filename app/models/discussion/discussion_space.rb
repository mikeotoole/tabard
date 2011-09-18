class DiscussionSpace < ActiveRecord::Base
end

# == Schema Information
#
# Table name: discussion_spaces
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  user_profile_id :integer
#  game_id         :integer
#  community_id    :integer
#  created_at      :datetime
#  updated_at      :datetime
#


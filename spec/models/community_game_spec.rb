# == Schema Information
#
# Table name: community_games
#
#  id                         :integer          not null, primary key
#  community_id               :integer
#  game_id                    :integer
#  game_announcement_space_id :integer
#  info                       :text
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

require 'spec_helper'

describe CommunityGame do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: community_games
#
#  id                         :integer          not null, primary key
#  community_id               :integer
#  game_id                    :integer
#  game_announcement_space_id :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  deleted_at                 :datetime
#  info                       :hstore
#

require 'spec_helper'

describe CommunityGame do
  pending "add some examples to (or delete) #{__FILE__}"
end
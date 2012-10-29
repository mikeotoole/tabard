# == Schema Information
#
# Table name: played_games
#
#  id              :integer          not null, primary key
#  game_id         :integer
#  user_profile_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe PlayedGame do
  pending "add some examples to (or delete) #{__FILE__}"
end

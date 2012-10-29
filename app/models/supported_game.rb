###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an association between a game and a community that participates (supports) it.
###
class SupportedGame < ActiveRecord::Base
end

# == Schema Information
#
# Table name: supported_games
#
#  id                         :integer          not null, primary key
#  community_id               :integer
#  game_id                    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  game_announcement_space_id :integer
#  name                       :string(255)
#  game_type                  :string(255)
#  deleted_at                 :datetime
#


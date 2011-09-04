###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an association between a game and a community that participates (supports) it.
###
class SupportedGame < ActiveRecord::Base

###
# Attribute accessible
###
#TODO Do we need these?
  #attr_accessible :community, :game

  belongs_to :community
  belongs_to :game
end

# == Schema Information
#
# Table name: supported_games
#
#  id           :integer         not null, primary key
#  community_id :integer
#  game_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#


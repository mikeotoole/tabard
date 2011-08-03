=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents an association between a game and a community that participates (supports) it.
=end
class SupportedGame < ActiveRecord::Base
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


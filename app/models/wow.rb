=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents the World of Warcraft game.
=end
class Wow < Game
  has_many :wow_characters, :foreign_key => :game_id, :dependent => :destroy
  
=begin
  This method gets all of the WOW characters.
  [Returns] An array that contains all of the WOW characters.
=end
  def characters
    self.wow_characters
  end
end


# == Schema Information
#
# Table name: games
#
#  id                            :integer         not null, primary key
#  name                          :string(255)
#  created_at                    :datetime
#  updated_at                    :datetime
#  type                          :string(255)
#  is_active                     :boolean         default(TRUE)
#  announcement_space_id         :integer
#  character_discussion_space_id :integer
#


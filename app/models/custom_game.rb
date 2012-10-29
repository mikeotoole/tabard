###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Custom Game.
###
class CustomGame < Game
end

# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  info       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)
#


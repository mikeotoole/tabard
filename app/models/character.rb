###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Game. Only subclasses of this should be created.
###
class Character < ActiveRecord::Base
###
# Constants
###
  #VALID_CHARACTERS = [['World of Warcraft', 'Wow'], ['Star Wars: The Old Republic', 'Swtor'], ['Minecraft', 'Minecraft'], ['Custom Game', 'CustomGame']]
###
# Attribute accessible
###
  attr_accessible :about, :avatar, :remote_avatar_url, :info, :name, :type, :played_game_id

###
# Associations
###
  belongs_to :played_game

###
# Validators
###

###
# Public Methods
###

###
# Uploaders
###
  mount_uploader :avatar, AvatarUploader

###
# H-Store
###
  # Setup info to use Hstore. This should not be needed for Rails 4.
  serialize :info, ActiveRecord::Coders::Hstore

###
# Instance Methods
###
end

# == Schema Information
#
# Table name: characters
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  avatar         :string(255)
#  about          :text
#  played_game_id :integer
#  info           :hstore
#  type           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#


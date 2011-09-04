###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Star Wars the Old Republic character.
###
class SwtorCharacter < BaseCharacter

###
# Attribute accessors
###
	###
	#  This attribute is the avatar for this SWTOR character. It maps to the AvatarUploader.
	###
  attr_accessor :avatar

	###
	# This attribute is the avatar cache for this SWTOR character. It is used by the AvatarUploader.
	###
  attr_accessor :avatar_cache

	###
	# This attribute is the avatar removal for this SWTOR character. It is used by the AvatarUploader.
	###
  attr_accessor :remove_avatar

###
# Attribute accessible
###
#TODO Do wee need these?
  #attr_accessible :name, :server, :game, :discussion

###
# Associations
###
  belongs_to :swtor, :foreign_key => :game_id

###
# Validators
###
  validates_presence_of :swtor

###
# Uploaders
###
  mount_uploader :avatar, AvatarUploader #TODO can this be moved to base_character?

	###
	# This method is added for removing an avatar. Code snippet I found on the internet to prevent noisy file not found errors. -JW
	###
  def remove_avatar! #TODO can this be moved to base_character?
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
    end
  end

	###
	# This method is added for removing a previously stored avatar. Code snippet I found on the internet to prevent noisy file not found errors. -JW
	###
  def remove_previously_stored_avatar #TODO can this be moved to base_character?
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
      @previous_model_for_avatar = nil
    end
  end

	###
	# This method gets the display name for the character.
	# [Returns] A string that contains the name of this character.
	###
  def display_name
    self.name
  end

	###
	# This method gets the game for the character.
	# [Returns] The SWTOR game.
	###
  def game
    self.swtor
  end

	###
	# This method gets the description for the character.
	# [Returns] A string that contains the description of the character.
	###
  def description
    "SWTOR Character"
  end

end

# == Schema Information
#
# Table name: swtor_characters
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  server     :string(255)
#  game_id    :integer
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#


=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents a World of Warcraft character.
=end
class WowCharacter < BaseCharacter

=begin
  This attribute is the avatar for this WOW character. It maps to the AvatarUploader.
=end
  attr_accessor :avatar

=begin
  This attribute is the avatar cache for this WOW character. It is used by the AvatarUploader.
=end
  attr_accessor :avatar_cache

=begin
  This attribute is the avatar removal for this WOW character. It is used by the AvatarUploader.
=end
  attr_accessor :remove_avatar

  #attr_accessible :name, :faction, :race, :level, :server, :game, :discussion

  belongs_to :wow, :foreign_key => :game_id

  validates_presence_of :wow

  #uploaders
  mount_uploader :avatar, AvatarUploader

=begin
  This method is added for removing an avatar. Code snippet I found on the internet to prevent noisy file not found errors. -JW
=end
  def remove_avatar!
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
    end
  end

=begin
  This method is added for removing a previously stored avatar. Code snippet I found on the internet to prevent noisy file not found errors. -JW
=end
  def remove_previously_stored_avatar
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
      @previous_model_for_avatar = nil
    end
  end

=begin
  This method gets the display name for the character.
  [Returns] A string that contains the name of this character.
=end
  def display_name
    self.name
  end

=begin
  This method gets the game for the character.
  [Returns] The WOW game.
=end
  def game
    self.wow
  end

=begin
  This method gets the description for the character.
  [Returns] A string that contains the description of the character.
=end
  def description
    "WoW Character"
  end

end

# == Schema Information
#
# Table name: wow_characters
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  faction       :string(255)
#  race          :string(255)
#  level         :integer
#  server        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  game_id       :integer
#  discussion_id :integer
#  avatar        :string(255)
#


###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for both SwtorCharacters and WowCharacters.
###
class CharacterObserver < ActiveRecord::Observer
  observe :wow_character, :swtor_character, :minecraft_character

  # Creates an activity when a character is updated.
  def after_update(character)
    if character.changed?
      change = character.changed == ["avatar", "updated_at"] ? "avatar" : "edited"

      Activity.create!( user_profile: character.user_profile,
                        target: character.character_proxy,
                        action: change)
    end
  end

  # removes comment
  def after_destroy(character)
    Activity.where(target_type: character.character_proxy.class.to_s, target_id: character.character_proxy.id).destroy_all
  end
end

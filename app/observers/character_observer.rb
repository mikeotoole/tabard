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
      unless (character.changed == ["avatar", "updated_at"] and not character.avatar.cached?.present?)
        change = (character.changed == ["avatar", "updated_at"] and character.avatar.cached?.present?) ? "avatar" : "edited"
        Activity.create!({user_profile: character.user_profile,
                          target: character.character_proxy,
                          action: change}, without_protection: true)
      end
    end
    return true
  end

  # removes comment
  def after_destroy(character)
    Activity.where(target_type: character.character_proxy.class.to_s, target_id: character.character_proxy.id).destroy_all
    return true
  end
end

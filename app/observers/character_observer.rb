###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for both SwtorCharacters and WowCharacters.
###
class CharacterObserver < ActiveRecord::Observer
  observe :wow_character, :swtor_character
  
  def after_update(character)
    if character.changed?
      change = character.changed == ["avatar", "updated_at"] ? "avatar" : "updated"
      puts character.changed.to_yaml
    
      Activity.create!( :user_profile => character.user_profile, 
                        :target => character.character_proxy, 
                        :action => change)
    end                      
  end
end
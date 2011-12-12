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
      change = change ? "updated" : "avatar" if character.avatar_changed?
    
      Activity.create!( :user_profile => character.user_profile, 
                        :target => character, 
                        :action => change)
    end                      
  end
end
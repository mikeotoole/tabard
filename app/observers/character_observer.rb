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
    Activity.create!( :user_profile => character.user_profile, 
                      :target => character, 
                      :action => "updated character")
  end
end
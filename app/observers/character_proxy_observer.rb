###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for CharacerProxy. It is used to create an activity when a new character is created.
###
class CharacterProxyObserver < ActiveRecord::Observer

  # Creates an activity when a character is created.
  def after_create(character_proxy)
    Activity.create!( user_profile: character_proxy.user_profile,
                      target: character_proxy.is_a?(CharacterProxy) ? character_proxy : character_proxy.character,
                      action: "created")
  end

  #removes activity
  def after_destroy(character_proxy)
    target = (character_proxy.is_a?(CharacterProxy) ? character_proxy : character_proxy.character)
    Activity.where(target_type: target.class.to_s, target_id: target.id).destroy_all
  end
end

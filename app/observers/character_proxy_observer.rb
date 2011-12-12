###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for CharacerProxy. It is used to create an activity when a new character is created.
###
class CharacterProxyObserver < ActiveRecord::Observer
  
  def after_create(character_proxy)
    Activity.create!( :user_profile => character_proxy.user_profile, 
                      :target => character_proxy.is_a?(CharacterProxy) ? character_proxy : character_proxy.character, 
                      :action => "created")
  end
end
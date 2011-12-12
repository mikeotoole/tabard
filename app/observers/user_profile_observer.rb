###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for UserProfile.
###
class UserProfileObserver < ActiveRecord::Observer
  
  # Creates an activity when a new user joins Brutal Venom.
  def after_create(user_profile)
    Activity.create!( :user_profile => user_profile, 
                      :target => user_profile,
                      :action => "joined")
  end
  
  # Creates a new activity when a user updates profile display_name, description, or title.
  def before_save(user_profile)
    if user_profile.persisted? and user_profile.changed?

      change = user_profile.display_name_changed? ? "display name" : nil
      change = change ? "profile" : "description" if user_profile.description_changed?
      change = change ? "profile" : "title" if user_profile.title_changed?
      change = change ? "profile" : "avatar" if user_profile.avatar_changed?
      change = change ? change : "profile"
      
      Activity.create!( :user_profile => user_profile, 
                        :target => user_profile,
                        :action => change)
    end    
  end
end
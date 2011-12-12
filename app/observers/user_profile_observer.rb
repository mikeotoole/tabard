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
                      :action => "joined Crumblin")
  end
  
  # Creates a new activity when a user updates profile display_name, description, or title.
  def before_save(user_profile)
    if user_profile.persisted?
      org_user_profile = UserProfile.find(user_profile)
      
      unless org_user_profile.display_name == user_profile.display_name
        Activity.create!( :user_profile => user_profile, 
                          :target => user_profile,
                          :action => "updated display name")
      end
      
      if not user_profile.description.blank? and not org_user_profile.description == user_profile.description
        Activity.create!( :user_profile => user_profile, 
                          :target => user_profile,
                          :action => "updated description")
      end
      
      if not user_profile.title.blank? and not org_user_profile.title == user_profile.title
        Activity.create!( :user_profile => user_profile, 
                          :target => user_profile,
                          :action => "updated title")
      end
    end    
  end
end
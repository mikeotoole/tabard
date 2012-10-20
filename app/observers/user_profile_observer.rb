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
    Activity.create!( {user_profile: user_profile,
                      target: user_profile,
                      action: "joined"}, without_protection: true)
    return true
  end

  # Creates a new activity when a user updates profile display_name, description, or title.
  def after_update(user_profile)
    if user_profile.changed?
      unless (user_profile.changed == ["avatar", "updated_at"] and not user_profile.avatar.cached?.present?)
        change = user_profile.display_name_changed? ? "player name" : nil
        change = change ? "profile" : "description" if user_profile.description_changed?
        change = change ? "profile" : "title" if user_profile.title_changed?
        change = change ? "profile" : "avatar" if user_profile.avatar.cached?.present?
        change = change ? change : "profile"

        Activity.create!( {user_profile: user_profile,
                          target: user_profile,
                          action: change}, without_protection: true)
      end
    end
    return true
  end

  # removes activity
  def after_destroy(user_profile)
    target = user_profile
    Activity.where(target_type: target.class.to_s, target_id: target.id).destroy_all
    return true
  end
end

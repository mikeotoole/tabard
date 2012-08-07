###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for user profiles.
###
class RolesController < ApplicationController
  before_filter :block_unauthorized_user!
  def update
    @user_profile = UserProfile.find_by_id(params[:user_profile_id])
    @role = Role.find_by_id(params[:id])

    unless @user_profile.blank? or @role.blank?
      temp_ability = Ability.new(current_user)
      temp_ability.dynamicContextRules(current_user, @role.community)
      raise CanCan::AccessDenied unless temp_ability.can? :can_accept, @role and @user_profile.is_member?(@role.community)
      if @user_profile.roles.include?(@role)
        if @user_profile.remove_role(@role)
          # Removed new role success
        else
          # Failure
        end
      else
        if @user_profile.add_new_role(@role)
          # Added new role success
        else
          # Failure
        end
      end
    else
      # Oh Noes! Wrong info!
    end
  end
end
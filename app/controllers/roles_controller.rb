###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for user profiles.
###
class RolesController < ApplicationController
  before_filter :block_unauthorized_user!

  # This updates roles
  def update
    @user_profile = UserProfile.find_by_id(params[:user_profile_id])
    @role = Role.find_by_id(params[:id])

    unless @user_profile.blank? or @role.blank?
      temp_ability = Ability.new(current_user)
      temp_ability.dynamicContextRules(current_user, @role.community)
      raise CanCan::AccessDenied unless temp_ability.can? :accept, @role and @user_profile.is_member?(@role.community)
      if @user_profile.roles.include?(@role)
        if @user_profile.remove_role(@role)
          return render json: { success: true, assigned: false }
        else
          return render json: { success: false }
        end
      else
        if @user_profile.add_new_role(@role)
          return render json: { success: true, assigned: true }
        else
          return render json: { success: false }
        end
      end
    end
    render json: { success: false }
  end
end

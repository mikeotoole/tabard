###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for community invites.
###
class CommunityInvitesController < ApplicationController
  respond_to :html
  ###
  # Before Filters
  ###
  before_filter :block_unauthorized_user!

###
# REST Actions
###
  # POST /communities(.:format)
  def create
    @community_invite = CommunityInvite.new(params[:community_invite])
    temp_ability = Ability.new(current_user)
    temp_ability.dynamicContextRules(current_user, @community_invite.community)
    temp_ability.authorize! :create, @community_invite
    add_new_flash_message "#{@community_invite.applicant_display_name} has been invited to #{@community_invite.community_name}", 'success' if @community_invite.save!
    respond_with(@community_invite, location: @community_invite.applicant)
  end
end
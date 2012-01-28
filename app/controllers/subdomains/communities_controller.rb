###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for communities.
###
class Subdomains::CommunitiesController < SubdomainsController
  respond_to :html
  ###
  # Before Filters
  ###
  before_filter :authenticate_user!
  load_and_authorize_resource

###
# REST Actions
###
  # GET /communities/:id/edit(.:format)
  def edit
  end

  # PUT /communities/:id(.:format)
  def update
    if @community.update_attributes(params[:community])
      add_new_flash_message 'Your changes have been saved.', 'success'
    else
      add_new_flash_message 'Error. Unable to save changes.', 'alert'
    end
    respond_with(@community, :location => edit_community_url(@community))
  end

#   # DELETE /communities/:id(.:format)
#   def destroy
#     Community.delay.destory_community(@community.id)
#     add_new_flash_message('Community is being removed.')
#     redirect_to root_url
#   end
end

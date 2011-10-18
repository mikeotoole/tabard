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
    @community.update_attributes(params[:community])
    respond_with(@community)
  end
end

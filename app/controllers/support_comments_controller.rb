###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling support tickets
###
class SupportCommentsController < ApplicationController
  before_filter :block_unauthorized_user!
  respond_to :html, :js
  before_filter :load_models
  load_and_authorize_resource :support_ticket

###
# REST Actions
###
  # New
  def new
    @support_comment = (@support_ticket.blank? ? nil : @support_ticket.support_comments.new)
  end

  # Create
  def create
    @support_comment = (@support_ticket.blank? ? nil : @support_ticket.support_comments.new(params[:support_comment]))
    @support_comment.user_profile = current_user.user_profile
    authorize! :create, @support_comment
    if @support_comment.save
      flash[:success] = "Your comment has been posted."
      respond_with @support_comment, location: support_url(@support_ticket)
    else
      flash[:alert] = "Your comment was unable to be posted."
      render "support_tickets/show"
    end
  end

  # Loads the models for cancan.
  def load_models
    @support_ticket = current_user.support_tickets.find_by_id(params[:support_id])
  end
end
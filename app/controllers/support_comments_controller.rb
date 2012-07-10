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
  def new
    @support_comment = (@support_ticket.blank? ? nil : @support_ticket.support_comments.new)
  end

  def create
    @support_comment = (@support_ticket.blank? ? nil : @support_ticket.support_comments.new(params[:support_comment]))
    @support_comment.user_profile = current_user.user_profile
    authorize! :create, @support_comment
    add_new_flash_message "Your comment has been added.", 'success' if @support_comment.save
    respond_with @support_comment, :location => @support_ticket
  end

  def load_models
    @support_ticket = current_user.support_tickets.find_by_id(params[:support_id])
  end
end
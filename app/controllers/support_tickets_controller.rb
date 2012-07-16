###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling support tickets
###
class SupportTicketsController < ApplicationController
  before_filter :block_unauthorized_user!, except: [:index]
  respond_to :html, :js
  load_and_authorize_resource through: :current_user, except: [:index]

###
# REST Actions
###
  # Index
  def index
    @support_tickets = current_user.support_tickets.order('status DESC').order('updated_at DESC').includes(:support_comments).page(params[:page]).per(10) if user_signed_in?
  end

  # Show
  def show
  end

  # New
  def new
  end

  # Create
  def create
    @support_ticket.status = SupportTicket::DEFAULT_STATUS
    flash[:success] = "Your ticket has been created. Someone will get started on this issue soon." if @support_ticket.save
    respond_with @support_ticket, location: support_index_url
  end

  # Close ticket
  # PUT /support/:id/status/:status
  def status
    if @support_ticket.update_attributes(status: params[:status])
      flash[:success] = 'The ticket has been closed.'
    else
      flash[:alert] = 'An error prevented us from closing the ticket.'
    end
    redirect_to support_index_url
  end

end
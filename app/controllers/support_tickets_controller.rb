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
    @support_ticket = SupportTicket.new()
    @support_tickets = current_user.support_tickets.order('status DESC').order('updated_at DESC').includes(support_comments: [:admin_user, :user_profile]).page(params[:page]).per(10) if user_signed_in?
  end

  # Show
  def show
    unless @support_ticket.status == 'Closed'
      if @support_ticket.admin_user
        flash.now[:success] = "#{@support_ticket.admin_user_display_name} is working to resolve this issue. You're in good hands!"
      else
        flash.now[:notice] = "The next available Guild.io agent will begin working to resolve your issue soon."
      end
    end
    @support_comment = @support_ticket.support_comments.new
  end

  # Create
  def create
    @support_ticket.status = SupportTicket::DEFAULT_STATUS
    if @support_ticket.save
      redirect_to support_url(@support_ticket)
    else
      flash[:error] = "The description was blank, so a support ticket could not be created."
      redirect_to support_index_url
    end
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
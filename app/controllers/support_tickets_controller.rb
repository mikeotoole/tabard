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
    add_new_flash_message "Your ticket has been created. Someone will get started on this issue soon.", 'success' if @support_ticket.save
    respond_with @support_ticket, location: support_index_url
  end

end
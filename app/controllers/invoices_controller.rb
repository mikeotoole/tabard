###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling all invoices for the current user.
###
class InvoicesController < ApplicationController
  respond_to :html, :js

  skip_before_filter :ensure_not_ssl_mode
  skip_before_filter :limit_subdomain_access
  before_filter :ensure_secure_subdomain

  # GET /statements
  def index
    @invoices = current_user.invoices.historical
  end

  # GET /statements/:id
  def show
    @invoice = current_user.invoices.find(params[:id])
  end
end

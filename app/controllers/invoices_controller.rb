###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling all invoices for the current user.
###
class InvoicesController < PaymentController
  respond_to :html, :js

  # GET /statements
  def index
    @invoices = current_user.invoices.historical
  end

  # GET /statements/:id
  def show
    @invoice = current_user.invoices.find(params[:id])
  end
end

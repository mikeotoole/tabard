###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This helper module is for invoices.
###
module InvoiceHelper

  # This gets the status for the specified invoice.
  def invoice_status(invoice)
    if invoice.paid_date.blank?
      invoice.is_closed ? 'Closed' : 'Open'
    else
      "Paid on #{invoice.paid_date.strftime("%B %d, %Y")}"
    end
  end

end

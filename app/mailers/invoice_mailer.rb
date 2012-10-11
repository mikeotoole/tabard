###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a mailer used to notify users about invoices.
###
class InvoiceMailer < ActionMailer::Base
  default from: "Tabard <noreply@tabard.co>",
          content_type: "text/html"
  layout 'mailer'

  # Tell user payment was successful
  def payment_successful(invoice_id)
  end

  # Tell user payment failed
  def payment_failed(invoice_id)
  end
end

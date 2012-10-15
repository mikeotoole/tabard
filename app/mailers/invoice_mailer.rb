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
    @invoice = Invoice.find_by_id(invoice_id)
    @url = invoice_url(@invoice)
    @user_profile = @invoice.user_profile
    mail(to: @user_profile.email, subject: "Tabard: Payment Receipt") do |format|
      format.html { render "mailers/payment_successful" }
    end
  end

  # Tell user payment failed
  def payment_failed(invoice_id, message_short, message_full=nil)
    @invoice = Invoice.find_by_id(invoice_id)
    @url = invoice_url(@invoice)
    @user_profile = @invoice.user_profile
    @message_short = message_short
    @message_full = message_full
    mail(to: @user_profile.email, subject: "Tabard: Payment Error") do |format|
      format.html { render "mailers/payment_failed" }
    end
  end
end

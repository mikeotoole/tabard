=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is for handling status codes.
=end
class StatusCodeController < ApplicationController
  layout = 'status_codes'
  respond_to :html
  def invoke_404
    render "status_code/invoke_404", :layout => "status_codes", :status => :not_found
  end

end

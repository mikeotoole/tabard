class StatusCodeController < ApplicationController
  respond_to :html, :xml
  def invoke_404
    true
  end

end

class InvoicesController < ApplicationController
  respond_to :html, :js

  skip_before_filter :ensure_not_ssl_mode
  skip_before_filter :limit_subdomain_access
  before_filter :ensure_secure_subdomain

  def index
    @invoices = current_user.invoices
  end
  
  def show
    @invoice = current_user.invoices.find_by_id(params[:id])
  end
end

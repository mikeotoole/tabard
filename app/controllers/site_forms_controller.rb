class SiteFormsController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate
  
  # GET /site_forms
  # GET /site_forms.xml
  def index
      @site_form = SiteForm.published
  
      respond_with @site_form
  end
  
end

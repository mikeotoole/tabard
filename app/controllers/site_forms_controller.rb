class SiteFormsController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate
  
  # GET /site_forms
  # GET /site_forms.xml
  def index
    if current_user.can_update("SiteForm") #if user has permission to view submissions. See comment below.
      @site_form = SiteForm.find(:all, :conditions => {:registration_application_form => false})
    else # See the view. The links to the submissions will need to be hidden.
      @site_form = SiteForm.published
    end
      respond_with @site_form
  end
end

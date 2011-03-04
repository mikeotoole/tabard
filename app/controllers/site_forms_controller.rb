class SiteFormsController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate
  
  # GET /site_forms
  # GET /site_forms.xml
  def index
      @site_forms = SiteForm.find(:all, :conditions => {:registration_application_form => false})
      @site_forms.delete_if {|site_form| !site_form.check_user_show_permissions(current_user)}
      respond_with @site_forms
  end
end

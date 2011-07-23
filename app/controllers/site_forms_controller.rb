class SiteFormsController < ApplicationController
  respond_to :html
  before_filter :authenticate

  def index
      @site_forms = SiteForm.find(:all, :conditions => {:registration_application_form => false})
      @site_forms.delete_if {|site_form| !site_form.check_user_show_permissions(current_user)}
      
      @show = current_user.can_show("SiteForm") 
      
      respond_with @site_forms
  end
end

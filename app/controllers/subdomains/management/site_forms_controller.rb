=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This controller is handling site forms within the scope of managment of subdomains (communities).
=end
class Subdomains::Management::SiteFormsController < SubdomainsController
  # TODO This controller needs permission checking - JW
  respond_to :html, :xml
  before_filter :authenticate

  def index
      @site_form = @community.site_forms.all  
      respond_with(@site_form)
  end
  
  def show
    @site_form = @community.site_forms.find(params[:id])
    respond_with(@site_form)
  end

  def new
    @site_form = @community.site_forms.new
    respond_with(@site_form)
  end

  def edit
      @site_form = @community.site_forms.find(params[:id])
      respond_with(@site_form)
  end

  def create
    @site_form = @community.site_forms.new(params[:site_form])
    @site_form.registration_application_form = false
    if @site_form.save    
      params[:notifications].each do |profile_id|
        Notification.create(:user_profile_id => profile_id, :site_form_id =>  @site_form.id)
      end if params[:notifications]  
      add_new_flash_message('Form was successfully created.')
    end
    grab_all_errors_from_model(@site_form)
    respond_with([:management,@site_form])
  end

  def update
    @site_form = @community.site_forms.find(params[:id])
    if @site_form.update_attributes(params[:site_form])
      @site_form.notifications.each do |notification|
        notification.destroy unless params[:notifications].include?(notification.user_profile)
      end
      params[:notifications].each do |profile_id|
        Notification.create(:user_profile_id => profile_id, :site_form_id =>  @site_form.id) unless @site_form.profile_notifications.include?(profile_id)
      end       
      add_new_flash_message('Form was successfully updated.')
    end
    grab_all_errors_from_model(@site_form)
    respond_with([:management, @site_form])
  end

  def destroy
    @site_form = @community.site_forms.find(params[:id])
    
    if @site_form.registration_application_form != true
      @site_form.destroy
      respond_to do |format|
        format.html { redirect_to(management_site_forms_path) }
        format.xml  { head :ok }
      end
    else
      add_new_flash_message('The registration application form can not be deleted.',"alert")
      respond_to do |format|
        format.html { redirect_to(management_site_forms_path) }
        format.xml  { head :ok }
      end
    end
  end
end  
  
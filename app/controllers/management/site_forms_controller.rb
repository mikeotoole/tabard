class Management::SiteFormsController < Communities::CommunitiesController
  respond_to :html, :xml
  before_filter :authenticate
  # GET /management/site_forms
  # GET /management/site_forms.xml
  def index
      @site_form = @community.site_forms.all
  
      respond_with(@site_form)
  end
  
  def show
    @site_form = @community.site_forms.find(params[:id])

    respond_with(@site_form)
  end

  # GET /management/site_forms/new
  # GET /management/site_forms/new.xml
  def new
    @site_form = @community.site_forms.new

    respond_with(@site_form)
  end

  # GET /management/site_forms/1/edit
  def edit
      @site_form = @community.site_forms.find(params[:id])
      respond_with(@site_form)
  end

  # POST /management/site_forms
  # POST /management/site_forms.xml
  def create
    @site_form = @community.site_forms.new(params[:site_form])

    @site_form.registration_application_form = false
    respond_to do |format|
      if @site_form.save
        
        params[:notifications].each do |profile_id|
          Notification.create(:user_profile_id => profile_id, :site_form_id =>  @site_form.id)
        end if params[:notifications]
        
        add_new_flash_message('Form was successfully created.')
        
        format.html { redirect_to(management_site_form_path(@site_form)) }
        format.xml  { render :xml => @site_form, :status => :created }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /management/site_forms/1
  # PUT /management/site_forms/1.xml
  def update
      @site_form = @community.site_forms.find(params[:id])
    respond_to do |format|
      if @site_form.update_attributes(params[:site_form])
        
        @site_form.notifications.each do |notification|
          notification.destroy unless params[:notifications].include?(notification.user_profile)
        end
        
        params[:notifications].each do |profile_id|
          Notification.create(:user_profile_id => profile_id, :site_form_id =>  @site_form.id) unless @site_form.profile_notifications.include?(profile_id)
        end       
        
        add_new_flash_message('Form was successfully updated.')
        
        format.html { redirect_to(management_site_form_path(@site_form)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /management/site_forms/1
  # DELETE /management/site_forms/1.xml
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
  
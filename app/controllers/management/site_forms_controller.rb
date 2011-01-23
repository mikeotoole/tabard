class Management::SiteFormsController < ApplicationController
    before_filter :authenticate
  # GET /management/site_forms
  # GET /management/site_forms.xml
  def index
      @site_form = SiteForm.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @site_form }
      end
  end
  
  def show
    @site_form = SiteForm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site_form }
    end
  end

  # GET /management/site_forms/new
  # GET /management/site_forms/new.xml
  def new
    @site_form = SiteForm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site_form }
    end
  end

  # GET /management/site_forms/1/edit
  def edit
      @site_form = SiteForm.find(params[:id])
  end

  # POST /management/site_forms
  # POST /management/site_forms.xml
  def create
    @site_form = SiteForm.new(params[:site_form])

    respond_to do |format|
      if @site_form.save
        format.html { redirect_to(management_site_form_path(@site_form), :notice => 'Form was successfully created.') }
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
      @site_form = SiteForm.find(params[:id])
    respond_to do |format|
      if @site_form.update_attributes(params[:site_form])
        format.html { redirect_to(management_site_forms_path, :notice => 'Form was successfully updated.') }
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
      @site_form = SiteForm.find(params[:id])
      @site_form.destroy
  
      respond_to do |format|
        format.html { redirect_to(management_site_forms_path) }
        format.xml  { head :ok }
      end
  end
end

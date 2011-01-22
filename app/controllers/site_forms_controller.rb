class SiteFormsController < ApplicationController
  # GET /site_forms
  # GET /site_forms.xml
  def index
    @site_forms = SiteForm.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @site_forms }
    end
  end

  # GET /site_forms/1
  # GET /site_forms/1.xml
  def show
    @site_form = SiteForm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site_form }
    end
  end

  # GET /site_forms/new
  # GET /site_forms/new.xml
  def new
    @site_form = SiteForm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site_form }
    end
  end

  # GET /site_forms/1/edit
  def edit
    @site_form = SiteForm.find(params[:id])
  end

  # POST /site_forms
  # POST /site_forms.xml
  def create
    @site_form = SiteForm.new(params[:site_form])

    respond_to do |format|
      if @site_form.save
        format.html { redirect_to(@site_form, :notice => 'Site form was successfully created.') }
        format.xml  { render :xml => @site_form, :status => :created, :location => @site_form }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /site_forms/1
  # PUT /site_forms/1.xml
  def update
    @site_form = SiteForm.find(params[:id])

    respond_to do |format|
      if @site_form.update_attributes(params[:site_form])
        format.html { redirect_to(@site_form, :notice => 'Site form was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /site_forms/1
  # DELETE /site_forms/1.xml
  def destroy
    @site_form = SiteForm.find(params[:id])
    @site_form.destroy

    respond_to do |format|
      format.html { redirect_to(site_forms_url) }
      format.xml  { head :ok }
    end
  end
end

class NewslettersController < ApplicationController
  respond_to :html, :xml 
  # GET /newsletters
  # GET /newsletters.xml
  def index
    @newsletters = Newsletter.all

    respond_with(@newsletters)
  end

  # GET /newsletters/1
  # GET /newsletters/1.xml
  def show
    @newsletter = Newsletter.find(params[:id])

    respond_with(@newsletter)
  end

  # GET /newsletters/new
  # GET /newsletters/new.xml
  def new
    @newsletter = Newsletter.new

    respond_with(@newsletter)
  end

  # GET /newsletters/1/edit
  def edit
    @newsletter = Newsletter.find(params[:id])
  end

  # POST /newsletters
  # POST /newsletters.xml
  def create
    @newsletter = Newsletter.new(params[:newsletter])

    respond_to do |format|
      if @newsletter.save
        add_new_flash_message('Newsletter was successfully created.')
        format.html { redirect_to(@newsletter) }
        format.xml  { render :xml => @newsletter, :status => :created, :location => @newsletter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @newsletter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /newsletters/1
  # PUT /newsletters/1.xml
  def update
    @newsletter = Newsletter.find(params[:id])

    respond_to do |format|
      if @newsletter.update_attributes(params[:newsletter])
        add_new_flash_message('Newsletter was successfully updated.')
        format.html { redirect_to(@newsletter) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @newsletter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /newsletters/1
  # DELETE /newsletters/1.xml
  def destroy
    @newsletter = Newsletter.find(params[:id])
    if @newsletter.destroy
      add_new_flash_message('Newsletter was successfully deleted.')
    end

    respond_to do |format|
      format.html { redirect_to(newsletters_url) }
      format.xml  { head :ok }
    end
  end
end

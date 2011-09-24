class CommunityApplicationsController < ApplicationController
  # GET /community_applications
  # GET /community_applications.json
  def index
    @community_applications = CommunityApplication.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @community_applications }
    end
  end

  # GET /community_applications/1
  # GET /community_applications/1.json
  def show
    @community_application = CommunityApplication.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @community_application }
    end
  end

  # GET /community_applications/new
  # GET /community_applications/new.json
  def new
    @community_application = CommunityApplication.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @community_application }
    end
  end

  # GET /community_applications/1/edit
  def edit
    @community_application = CommunityApplication.find(params[:id])
  end

  # POST /community_applications
  # POST /community_applications.json
  def create
    @community_application = CommunityApplication.new(params[:community_application])

    respond_to do |format|
      if @community_application.save
        format.html { redirect_to @community_application, notice: 'Community application was successfully created.' }
        format.json { render json: @community_application, status: :created, location: @community_application }
      else
        format.html { render action: "new" }
        format.json { render json: @community_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /community_applications/1
  # PUT /community_applications/1.json
  def update
    @community_application = CommunityApplication.find(params[:id])

    respond_to do |format|
      if @community_application.update_attributes(params[:community_application])
        format.html { redirect_to @community_application, notice: 'Community application was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @community_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /community_applications/1
  # DELETE /community_applications/1.json
  def destroy
    @community_application = CommunityApplication.find(params[:id])
    @community_application.destroy

    respond_to do |format|
      format.html { redirect_to community_applications_url }
      format.json { head :ok }
    end
  end
end

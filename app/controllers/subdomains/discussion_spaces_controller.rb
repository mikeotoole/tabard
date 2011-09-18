class Subdomains::DiscussionSpacesController < ApplicationController
  # GET /discussion_spaces
  # GET /discussion_spaces.json
  def index
    @discussion_spaces = DiscussionSpace.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @discussion_spaces }
    end
  end

  # GET /discussion_spaces/1
  # GET /discussion_spaces/1.json
  def show
    @discussion_space = DiscussionSpace.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @discussion_space }
    end
  end

  # GET /discussion_spaces/new
  # GET /discussion_spaces/new.json
  def new
    @discussion_space = DiscussionSpace.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @discussion_space }
    end
  end

  # GET /discussion_spaces/1/edit
  def edit
    @discussion_space = DiscussionSpace.find(params[:id])
  end

  # POST /discussion_spaces
  # POST /discussion_spaces.json
  def create
    @discussion_space = DiscussionSpace.new(params[:discussion_space])

    respond_to do |format|
      if @discussion_space.save
        format.html { redirect_to @discussion_space, notice: 'Discussion space was successfully created.' }
        format.json { render json: @discussion_space, status: :created, location: @discussion_space }
      else
        format.html { render action: "new" }
        format.json { render json: @discussion_space.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /discussion_spaces/1
  # PUT /discussion_spaces/1.json
  def update
    @discussion_space = DiscussionSpace.find(params[:id])

    respond_to do |format|
      if @discussion_space.update_attributes(params[:discussion_space])
        format.html { redirect_to @discussion_space, notice: 'Discussion space was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @discussion_space.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discussion_spaces/1
  # DELETE /discussion_spaces/1.json
  def destroy
    @discussion_space = DiscussionSpace.find(params[:id])
    @discussion_space.destroy

    respond_to do |format|
      format.html { redirect_to discussion_spaces_url }
      format.json { head :ok }
    end
  end
end

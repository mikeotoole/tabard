class PageSpacesController < ApplicationController
  # GET /page_spaces
  # GET /page_spaces.json
  def index
    @page_spaces = PageSpace.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @page_spaces }
    end
  end

  # GET /page_spaces/1
  # GET /page_spaces/1.json
  def show
    @page_space = PageSpace.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page_space }
    end
  end

  # GET /page_spaces/new
  # GET /page_spaces/new.json
  def new
    @page_space = PageSpace.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page_space }
    end
  end

  # GET /page_spaces/1/edit
  def edit
    @page_space = PageSpace.find(params[:id])
  end

  # POST /page_spaces
  # POST /page_spaces.json
  def create
    @page_space = PageSpace.new(params[:page_space])

    respond_to do |format|
      if @page_space.save
        format.html { redirect_to @page_space, notice: 'Page space was successfully created.' }
        format.json { render json: @page_space, status: :created, location: @page_space }
      else
        format.html { render action: "new" }
        format.json { render json: @page_space.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /page_spaces/1
  # PUT /page_spaces/1.json
  def update
    @page_space = PageSpace.find(params[:id])

    respond_to do |format|
      if @page_space.update_attributes(params[:page_space])
        format.html { redirect_to @page_space, notice: 'Page space was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @page_space.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_spaces/1
  # DELETE /page_spaces/1.json
  def destroy
    @page_space = PageSpace.find(params[:id])
    @page_space.destroy

    respond_to do |format|
      format.html { redirect_to page_spaces_url }
      format.json { head :ok }
    end
  end
end

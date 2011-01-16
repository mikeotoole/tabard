class TeamspeaksController < ApplicationController
  # GET /teamspeaks
  # GET /teamspeaks.xml
  def index
    @teamspeaks = Teamspeak.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teamspeaks }
    end
  end

  # GET /teamspeaks/1
  # GET /teamspeaks/1.xml
  def show
    @teamspeak = Teamspeak.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @teamspeak }
    end
  end

  # GET /teamspeaks/new
  # GET /teamspeaks/new.xml
  def new
    @teamspeak = Teamspeak.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @teamspeak }
    end
  end

  # GET /teamspeaks/1/edit
  def edit
    @teamspeak = Teamspeak.find(params[:id])
  end

  # POST /teamspeaks
  # POST /teamspeaks.xml
  def create
    @teamspeak = Teamspeak.new(params[:teamspeak])

    respond_to do |format|
      if @teamspeak.save
        format.html { redirect_to(@teamspeak, :notice => 'Teamspeak was successfully created.') }
        format.xml  { render :xml => @teamspeak, :status => :created, :location => @teamspeak }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @teamspeak.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teamspeaks/1
  # PUT /teamspeaks/1.xml
  def update
    @teamspeak = Teamspeak.find(params[:id])

    respond_to do |format|
      if @teamspeak.update_attributes(params[:teamspeak])
        format.html { redirect_to(@teamspeak, :notice => 'Teamspeak was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @teamspeak.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teamspeaks/1
  # DELETE /teamspeaks/1.xml
  def destroy
    @teamspeak = Teamspeak.find(params[:id])
    @teamspeak.destroy

    respond_to do |format|
      format.html { redirect_to(teamspeaks_url) }
      format.xml  { head :ok }
    end
  end
end

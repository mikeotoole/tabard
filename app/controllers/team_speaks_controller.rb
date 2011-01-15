class TeamSpeaksController < ApplicationController
  # GET /team_speaks
  # GET /team_speaks.xml
  def index
    @team_speaks = TeamSpeak.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @team_speaks }
    end
  end

  # GET /team_speaks/1
  # GET /team_speaks/1.xml
  def show
    @team_speak = TeamSpeak.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team_speak }
    end
  end

  # GET /team_speaks/new
  # GET /team_speaks/new.xml
  def new
    @team_speak = TeamSpeak.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team_speak }
    end
  end

  # GET /team_speaks/1/edit
  def edit
    @team_speak = TeamSpeak.find(params[:id])
  end

  # POST /team_speaks
  # POST /team_speaks.xml
  def create
    @team_speak = TeamSpeak.new(params[:team_speak])

    respond_to do |format|
      if @team_speak.save
        format.html { redirect_to(@team_speak, :notice => 'Team speak was successfully created.') }
        format.xml  { render :xml => @team_speak, :status => :created, :location => @team_speak }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team_speak.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /team_speaks/1
  # PUT /team_speaks/1.xml
  def update
    @team_speak = TeamSpeak.find(params[:id])

    respond_to do |format|
      if @team_speak.update_attributes(params[:team_speak])
        format.html { redirect_to(@team_speak, :notice => 'Team speak was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team_speak.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /team_speaks/1
  # DELETE /team_speaks/1.xml
  def destroy
    @team_speak = TeamSpeak.find(params[:id])
    @team_speak.destroy

    respond_to do |format|
      format.html { redirect_to(team_speaks_url) }
      format.xml  { head :ok }
    end
  end
end

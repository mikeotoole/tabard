class RosterAssignmentsController < ApplicationController
  # GET /roster_assignments
  # GET /roster_assignments.json
  def index
    @roster_assignments = RosterAssignment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @roster_assignments }
    end
  end

  # GET /roster_assignments/1
  # GET /roster_assignments/1.json
  def show
    @roster_assignment = RosterAssignment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @roster_assignment }
    end
  end

  # GET /roster_assignments/new
  # GET /roster_assignments/new.json
  def new
    @roster_assignment = RosterAssignment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @roster_assignment }
    end
  end

  # GET /roster_assignments/1/edit
  def edit
    @roster_assignment = RosterAssignment.find(params[:id])
  end

  # POST /roster_assignments
  # POST /roster_assignments.json
  def create
    @roster_assignment = RosterAssignment.new(params[:roster_assignment])

    respond_to do |format|
      if @roster_assignment.save
        format.html { redirect_to @roster_assignment, notice: 'Roster assignment was successfully created.' }
        format.json { render json: @roster_assignment, status: :created, location: @roster_assignment }
      else
        format.html { render action: "new" }
        format.json { render json: @roster_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /roster_assignments/1
  # PUT /roster_assignments/1.json
  def update
    @roster_assignment = RosterAssignment.find(params[:id])

    respond_to do |format|
      if @roster_assignment.update_attributes(params[:roster_assignment])
        format.html { redirect_to @roster_assignment, notice: 'Roster assignment was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @roster_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roster_assignments/1
  # DELETE /roster_assignments/1.json
  def destroy
    @roster_assignment = RosterAssignment.find(params[:id])
    @roster_assignment.destroy

    respond_to do |format|
      format.html { redirect_to roster_assignments_url }
      format.json { head :ok }
    end
  end
end

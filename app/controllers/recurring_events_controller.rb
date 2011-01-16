class RecurringEventsController < ApplicationController
  # GET /recurring_events
  # GET /recurring_events.xml
  def index
    @recurring_events = RecurringEvent.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @recurring_events }
    end
  end

  # GET /recurring_events/1
  # GET /recurring_events/1.xml
  def show
    @recurring_event = RecurringEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recurring_event }
    end
  end

  # GET /recurring_events/new
  # GET /recurring_events/new.xml
  def new
    @recurring_event = RecurringEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recurring_event }
    end
  end

  # GET /recurring_events/1/edit
  def edit
    @recurring_event = RecurringEvent.find(params[:id])
  end

  # POST /recurring_events
  # POST /recurring_events.xml
  def create
    @recurring_event = RecurringEvent.new(params[:recurring_event])

    respond_to do |format|
      if @recurring_event.save
        format.html { redirect_to(@recurring_event, :notice => 'Recurring event was successfully created.') }
        format.xml  { render :xml => @recurring_event, :status => :created, :location => @recurring_event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @recurring_event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recurring_events/1
  # PUT /recurring_events/1.xml
  def update
    @recurring_event = RecurringEvent.find(params[:id])

    respond_to do |format|
      if @recurring_event.update_attributes(params[:recurring_event])
        format.html { redirect_to(@recurring_event, :notice => 'Recurring event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recurring_event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recurring_events/1
  # DELETE /recurring_events/1.xml
  def destroy
    @recurring_event = RecurringEvent.find(params[:id])
    @recurring_event.destroy

    respond_to do |format|
      format.html { redirect_to(recurring_events_url) }
      format.xml  { head :ok }
    end
  end
end

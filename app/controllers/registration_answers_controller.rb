class RegistrationAnswersController < ApplicationController
  # GET /registration_answers
  # GET /registration_answers.xml
  def index
    @registration_answers = RegistrationAnswer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @registration_answers }
    end
  end

  # GET /registration_answers/1
  # GET /registration_answers/1.xml
  def show
    @registration_answer = RegistrationAnswer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @registration_answer }
    end
  end

  # GET /registration_answers/new
  # GET /registration_answers/new.xml
  def new
    @registration_answer = RegistrationAnswer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @registration_answer }
    end
  end

  # GET /registration_answers/1/edit
  def edit
    @registration_answer = RegistrationAnswer.find(params[:id])
  end

  # POST /registration_answers
  # POST /registration_answers.xml
  def create
    @registration_answer = RegistrationAnswer.new(params[:registration_answer])

    respond_to do |format|
      if @registration_answer.save
        add_new_flash_message('Registration answer was successfully created.')
        format.html { redirect_to(@registration_answer) }
        format.xml  { render :xml => @registration_answer, :status => :created, :location => @registration_answer }
      else
        grab_all_errors_from_model(@registration_answer)
        format.html { render :action => "new" }
        format.xml  { render :xml => @registration_answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /registration_answers/1
  # PUT /registration_answers/1.xml
  def update
    @registration_answer = RegistrationAnswer.find(params[:id])

    respond_to do |format|
      if @registration_answer.update_attributes(params[:registration_answer])
        add_new_flash_message('Registration answer was successfully updated.')
        format.html { redirect_to(@registration_answer) }
        format.xml  { head :ok }
      else
        grab_all_errors_from_model(@registration_answer)
        format.html { render :action => "edit" }
        format.xml  { render :xml => @registration_answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_answers/1
  # DELETE /registration_answers/1.xml
  def destroy
    @registration_answer = RegistrationAnswer.find(params[:id])
    if @registration_answer.destroy
      add_new_flash_message('Registration answer was successfully deleted.')
    end

    respond_to do |format|
      format.html { redirect_to(registration_answers_url) }
      format.xml  { head :ok }
    end
  end
end

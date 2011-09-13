class PredefinedAnswersController < ApplicationController
  # GET /predefined_answers
  # GET /predefined_answers.json
  def index
    @predefined_answers = PredefinedAnswer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @predefined_answers }
    end
  end

  # GET /predefined_answers/1
  # GET /predefined_answers/1.json
  def show
    @predefined_answer = PredefinedAnswer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @predefined_answer }
    end
  end

  # GET /predefined_answers/new
  # GET /predefined_answers/new.json
  def new
    @predefined_answer = PredefinedAnswer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @predefined_answer }
    end
  end

  # GET /predefined_answers/1/edit
  def edit
    @predefined_answer = PredefinedAnswer.find(params[:id])
  end

  # POST /predefined_answers
  # POST /predefined_answers.json
  def create
    @predefined_answer = PredefinedAnswer.new(params[:predefined_answer])

    respond_to do |format|
      if @predefined_answer.save
        format.html { redirect_to @predefined_answer, notice: 'Predefined answer was successfully created.' }
        format.json { render json: @predefined_answer, status: :created, location: @predefined_answer }
      else
        format.html { render action: "new" }
        format.json { render json: @predefined_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /predefined_answers/1
  # PUT /predefined_answers/1.json
  def update
    @predefined_answer = PredefinedAnswer.find(params[:id])

    respond_to do |format|
      if @predefined_answer.update_attributes(params[:predefined_answer])
        format.html { redirect_to @predefined_answer, notice: 'Predefined answer was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @predefined_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /predefined_answers/1
  # DELETE /predefined_answers/1.json
  def destroy
    @predefined_answer = PredefinedAnswer.find(params[:id])
    @predefined_answer.destroy

    respond_to do |format|
      format.html { redirect_to predefined_answers_url }
      format.json { head :ok }
    end
  end
end

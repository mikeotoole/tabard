class SelectQuestionsController < ApplicationController
  # GET /select_questions
  # GET /select_questions.json
  def index
    @select_questions = SelectQuestion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @select_questions }
    end
  end

  # GET /select_questions/1
  # GET /select_questions/1.json
  def show
    @select_question = SelectQuestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @select_question }
    end
  end

  # GET /select_questions/new
  # GET /select_questions/new.json
  def new
    @select_question = SelectQuestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @select_question }
    end
  end

  # GET /select_questions/1/edit
  def edit
    @select_question = SelectQuestion.find(params[:id])
  end

  # POST /select_questions
  # POST /select_questions.json
  def create
    @select_question = SelectQuestion.new(params[:select_question])

    respond_to do |format|
      if @select_question.save
        format.html { redirect_to @select_question, notice: 'Select question was successfully created.' }
        format.json { render json: @select_question, status: :created, location: @select_question }
      else
        format.html { render action: "new" }
        format.json { render json: @select_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /select_questions/1
  # PUT /select_questions/1.json
  def update
    @select_question = SelectQuestion.find(params[:id])

    respond_to do |format|
      if @select_question.update_attributes(params[:select_question])
        format.html { redirect_to @select_question, notice: 'Select question was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @select_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /select_questions/1
  # DELETE /select_questions/1.json
  def destroy
    @select_question = SelectQuestion.find(params[:id])
    @select_question.destroy

    respond_to do |format|
      format.html { redirect_to select_questions_url }
      format.json { head :ok }
    end
  end
end

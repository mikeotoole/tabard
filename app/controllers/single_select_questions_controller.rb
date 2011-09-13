class SingleSelectQuestionsController < ApplicationController
  # GET /single_select_questions
  # GET /single_select_questions.json
  def index
    @single_select_questions = SingleSelectQuestion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @single_select_questions }
    end
  end

  # GET /single_select_questions/1
  # GET /single_select_questions/1.json
  def show
    @single_select_question = SingleSelectQuestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @single_select_question }
    end
  end

  # GET /single_select_questions/new
  # GET /single_select_questions/new.json
  def new
    @single_select_question = SingleSelectQuestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @single_select_question }
    end
  end

  # GET /single_select_questions/1/edit
  def edit
    @single_select_question = SingleSelectQuestion.find(params[:id])
  end

  # POST /single_select_questions
  # POST /single_select_questions.json
  def create
    @single_select_question = SingleSelectQuestion.new(params[:single_select_question])

    respond_to do |format|
      if @single_select_question.save
        format.html { redirect_to @single_select_question, notice: 'Single select question was successfully created.' }
        format.json { render json: @single_select_question, status: :created, location: @single_select_question }
      else
        format.html { render action: "new" }
        format.json { render json: @single_select_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /single_select_questions/1
  # PUT /single_select_questions/1.json
  def update
    @single_select_question = SingleSelectQuestion.find(params[:id])

    respond_to do |format|
      if @single_select_question.update_attributes(params[:single_select_question])
        format.html { redirect_to @single_select_question, notice: 'Single select question was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @single_select_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /single_select_questions/1
  # DELETE /single_select_questions/1.json
  def destroy
    @single_select_question = SingleSelectQuestion.find(params[:id])
    @single_select_question.destroy

    respond_to do |format|
      format.html { redirect_to single_select_questions_url }
      format.json { head :ok }
    end
  end
end

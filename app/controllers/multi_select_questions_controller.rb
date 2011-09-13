class MultiSelectQuestionsController < ApplicationController
  # GET /multi_select_questions
  # GET /multi_select_questions.json
  def index
    @multi_select_questions = MultiSelectQuestion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @multi_select_questions }
    end
  end

  # GET /multi_select_questions/1
  # GET /multi_select_questions/1.json
  def show
    @multi_select_question = MultiSelectQuestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @multi_select_question }
    end
  end

  # GET /multi_select_questions/new
  # GET /multi_select_questions/new.json
  def new
    @multi_select_question = MultiSelectQuestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @multi_select_question }
    end
  end

  # GET /multi_select_questions/1/edit
  def edit
    @multi_select_question = MultiSelectQuestion.find(params[:id])
  end

  # POST /multi_select_questions
  # POST /multi_select_questions.json
  def create
    @multi_select_question = MultiSelectQuestion.new(params[:multi_select_question])

    respond_to do |format|
      if @multi_select_question.save
        format.html { redirect_to @multi_select_question, notice: 'Multi select question was successfully created.' }
        format.json { render json: @multi_select_question, status: :created, location: @multi_select_question }
      else
        format.html { render action: "new" }
        format.json { render json: @multi_select_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /multi_select_questions/1
  # PUT /multi_select_questions/1.json
  def update
    @multi_select_question = MultiSelectQuestion.find(params[:id])

    respond_to do |format|
      if @multi_select_question.update_attributes(params[:multi_select_question])
        format.html { redirect_to @multi_select_question, notice: 'Multi select question was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @multi_select_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /multi_select_questions/1
  # DELETE /multi_select_questions/1.json
  def destroy
    @multi_select_question = MultiSelectQuestion.find(params[:id])
    @multi_select_question.destroy

    respond_to do |format|
      format.html { redirect_to multi_select_questions_url }
      format.json { head :ok }
    end
  end
end

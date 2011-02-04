class TextQuestionsController < ApplicationController
  # GET /text_questions
  # GET /text_questions.xml
  def index
    @text_questions = TextQuestion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @text_questions }
    end
  end

  # GET /text_questions/1
  # GET /text_questions/1.xml
  def show
    @text_question = TextQuestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @text_question }
    end
  end

  # GET /text_questions/new
  # GET /text_questions/new.xml
  def new
    @text_question = TextQuestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @text_question }
    end
  end

  # GET /text_questions/1/edit
  def edit
    @text_question = TextQuestion.find(params[:id])
  end

  # POST /text_questions
  # POST /text_questions.xml
  def create
    @text_question = TextQuestion.new(params[:text_question])

    respond_to do |format|
      if @text_question.save
        format.html { redirect_to(@text_question, :notice => 'Text question was successfully created.') }
        format.xml  { render :xml => @text_question, :status => :created, :location => @text_question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @text_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /text_questions/1
  # PUT /text_questions/1.xml
  def update
    @text_question = TextQuestion.find(params[:id])

    respond_to do |format|
      if @text_question.update_attributes(params[:text_question])
        format.html { redirect_to(@text_question, :notice => 'Text question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @text_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /text_questions/1
  # DELETE /text_questions/1.xml
  def destroy
    @text_question = TextQuestion.find(params[:id])
    @text_question.destroy

    respond_to do |format|
      format.html { redirect_to(text_questions_url) }
      format.xml  { head :ok }
    end
  end
end

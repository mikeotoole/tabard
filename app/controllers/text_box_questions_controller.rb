class TextBoxQuestionsController < ApplicationController
  # GET /text_box_questions
  # GET /text_box_questions.xml
  def index
    @text_box_questions = TextBoxQuestion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @text_box_questions }
    end
  end

  # GET /text_box_questions/1
  # GET /text_box_questions/1.xml
  def show
    @text_box_question = TextBoxQuestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @text_box_question }
    end
  end

  # GET /text_box_questions/new
  # GET /text_box_questions/new.xml
  def new
    @text_box_question = TextBoxQuestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @text_box_question }
    end
  end

  # GET /text_box_questions/1/edit
  def edit
    @text_box_question = TextBoxQuestion.find(params[:id])
  end

  # POST /text_box_questions
  # POST /text_box_questions.xml
  def create
    @text_box_question = TextBoxQuestion.new(params[:text_box_question])

    respond_to do |format|
      if @text_box_question.save
        format.html { redirect_to(@text_box_question, :notice => 'Text box question was successfully created.') }
        format.xml  { render :xml => @text_box_question, :status => :created, :location => @text_box_question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @text_box_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /text_box_questions/1
  # PUT /text_box_questions/1.xml
  def update
    @text_box_question = TextBoxQuestion.find(params[:id])

    respond_to do |format|
      if @text_box_question.update_attributes(params[:text_box_question])
        format.html { redirect_to(@text_box_question, :notice => 'Text box question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @text_box_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /text_box_questions/1
  # DELETE /text_box_questions/1.xml
  def destroy
    @text_box_question = TextBoxQuestion.find(params[:id])
    @text_box_question.destroy

    respond_to do |format|
      format.html { redirect_to(text_box_questions_url) }
      format.xml  { head :ok }
    end
  end
end

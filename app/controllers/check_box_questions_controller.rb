class CheckBoxQuestionsController < ApplicationController
  # GET /check_box_questions
  # GET /check_box_questions.xml
  def index
    @check_box_questions = CheckBoxQuestion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @check_box_questions }
    end
  end

  # GET /check_box_questions/1
  # GET /check_box_questions/1.xml
  def show
    @check_box_question = CheckBoxQuestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @check_box_question }
    end
  end

  # GET /check_box_questions/new
  # GET /check_box_questions/new.xml
  def new
    @check_box_question = CheckBoxQuestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @check_box_question }
    end
  end

  # GET /check_box_questions/1/edit
  def edit
    @check_box_question = CheckBoxQuestion.find(params[:id])
  end

  # POST /check_box_questions
  # POST /check_box_questions.xml
  def create
    @check_box_question = CheckBoxQuestion.new(params[:check_box_question])

    respond_to do |format|
      if @check_box_question.save
        format.html { redirect_to(@check_box_question, :notice => 'Check box question was successfully created.') }
        format.xml  { render :xml => @check_box_question, :status => :created, :location => @check_box_question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @check_box_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /check_box_questions/1
  # PUT /check_box_questions/1.xml
  def update
    @check_box_question = CheckBoxQuestion.find(params[:id])

    respond_to do |format|
      if @check_box_question.update_attributes(params[:check_box_question])
        format.html { redirect_to(@check_box_question, :notice => 'Check box question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @check_box_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /check_box_questions/1
  # DELETE /check_box_questions/1.xml
  def destroy
    @check_box_question = CheckBoxQuestion.find(params[:id])
    @check_box_question.destroy

    respond_to do |format|
      format.html { redirect_to(check_box_questions_url) }
      format.xml  { head :ok }
    end
  end
end

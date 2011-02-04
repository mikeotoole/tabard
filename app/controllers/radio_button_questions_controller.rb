class RadioButtonQuestionsController < ApplicationController
  # GET /radio_button_questions
  # GET /radio_button_questions.xml
  def index
    @radio_button_questions = RadioButtonQuestion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @radio_button_questions }
    end
  end

  # GET /radio_button_questions/1
  # GET /radio_button_questions/1.xml
  def show
    @radio_button_question = RadioButtonQuestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @radio_button_question }
    end
  end

  # GET /radio_button_questions/new
  # GET /radio_button_questions/new.xml
  def new
    @radio_button_question = RadioButtonQuestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @radio_button_question }
    end
  end

  # GET /radio_button_questions/1/edit
  def edit
    @radio_button_question = RadioButtonQuestion.find(params[:id])
  end

  # POST /radio_button_questions
  # POST /radio_button_questions.xml
  def create
    @radio_button_question = RadioButtonQuestion.new(params[:radio_button_question])

    respond_to do |format|
      if @radio_button_question.save
        format.html { redirect_to(@radio_button_question, :notice => 'Radio button question was successfully created.') }
        format.xml  { render :xml => @radio_button_question, :status => :created, :location => @radio_button_question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @radio_button_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /radio_button_questions/1
  # PUT /radio_button_questions/1.xml
  def update
    @radio_button_question = RadioButtonQuestion.find(params[:id])

    respond_to do |format|
      if @radio_button_question.update_attributes(params[:radio_button_question])
        format.html { redirect_to(@radio_button_question, :notice => 'Radio button question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @radio_button_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /radio_button_questions/1
  # DELETE /radio_button_questions/1.xml
  def destroy
    @radio_button_question = RadioButtonQuestion.find(params[:id])
    @radio_button_question.destroy

    respond_to do |format|
      format.html { redirect_to(radio_button_questions_url) }
      format.xml  { head :ok }
    end
  end
end

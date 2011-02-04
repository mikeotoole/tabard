class RadioButtonQuestionsController < ApplicationController
  respond_to :html, :xml, :js
  
  # GET /radio_button_questions
  # GET /radio_button_questions.xml
  def index
    @radio_button_questions = RadioButtonQuestion.all

    respond_with(@radio_button_questions)
  end

  # GET /radio_button_questions/1
  # GET /radio_button_questions/1.xml
  def show
    @radio_button_question = RadioButtonQuestion.find(params[:id])

    respond_with(@radio_button_question)
  end

  # GET /radio_button_questions/new
  # GET /radio_button_questions/new.xml
  def new
    @radio_button_question = RadioButtonQuestion.new

    respond_with(@radio_button_question)
  end

  # GET /radio_button_questions/1/edit
  def edit
    @radio_button_question = RadioButtonQuestion.find(params[:id])
  end

  # POST /radio_button_questions
  # POST /radio_button_questions.xml
  def create
    @radio_button_question = RadioButtonQuestion.new(params[:radio_button_question])

      if @radio_button_question.save
        respond_with(@radio_button_question)
      else
        respond_to do |format|
         format.html { render :action => "new" }
         format.xml  { render :xml => @radio_button_question.errors, :status => :unprocessable_entity }
        end
      end
  end

  # PUT /radio_button_questions/1
  # PUT /radio_button_questions/1.xml
  def update
    @radio_button_question = RadioButtonQuestion.find(params[:id])
    @form = SiteForm.find(@radio_button_question.site_form_id)

    respond_to do |format|
      if @radio_button_question.update_attributes(params[:radio_button_question])
        format.html { redirect_to([:management, @form], :notice => 'Question was successfully updated.') }
        format.xml  { head :ok }
        format.js { redirect_to([:management, @form], :notice => 'Question was successfully updated.') }
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
    @form = SiteForm.find(@radio_button_question.site_form_id)
    
    @radio_button_question.destroy

    respond_to do |format|
      format.html { redirect_to([:management, @form]) }
      format.xml  { head :ok }
    end
  end
end

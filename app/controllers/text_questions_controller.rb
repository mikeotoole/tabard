class TextQuestionsController < ApplicationController
  respond_to :html, :xml, :js
  
  # GET /text_questions
  # GET /text_questions.xml
  def index
    @text_questions = TextQuestion.all

    respond_with(@text_questions)
  end

  # GET /text_questions/1
  # GET /text_questions/1.xml
  def show
    @text_question = TextQuestion.find(params[:id])

    respond_with(@text_question)
  end

  # GET /text_questions/new
  # GET /text_questions/new.xml
  def new
    @text_question = TextQuestion.new

    respond_with(@text_question)
  end

  # GET /text_questions/1/edit
  def edit
    @text_question = TextQuestion.find(params[:id])
  end

  # POST /text_questions
  # POST /text_questions.xml
  def create
    @text_question = TextQuestion.new(params[:text_question])

      if @text_question.save
        respond_with(@text_question)
      else
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @text_question.errors, :status => :unprocessable_entity }
        end
      end
  end

  # PUT /text_questions/1
  # PUT /text_questions/1.xml
  def update
    @old_text_question = TextQuestion.find(params[:id])
    @form = SiteForm.find(@old_text_question.site_form_id)
    
    @text_question = @old_text_question.clone
    
    @old_text_question.site_form_id = nil
    @old_text_question.save

    respond_to do |format|
      if @text_question.update_attributes(params[:text_question])
        format.html { redirect_to([:management, @form], :notice => 'Question was successfully updated.') }
        format.xml  { head :ok }
        format.js { redirect_to([:management, @form], :notice => 'Question was successfully updated.') }
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
    @form = SiteForm.find(@text_question.site_form_id)   

    @text_question.site_form_id = nil
    @text_question.save

    respond_to do |format|
      format.html { redirect_to([:management, @form]) }
      format.xml  { head :ok }
    end
  end
end

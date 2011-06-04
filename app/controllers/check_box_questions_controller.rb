class CheckBoxQuestionsController < ApplicationController
  respond_to :html, :xml, :js
  
  # GET /check_box_questions
  # GET /check_box_questions.xml
  def index
    @check_box_questions = CheckBoxQuestion.all

    respond_with(@check_box_questions)
  end

  # GET /check_box_questions/1
  # GET /check_box_questions/1.xml
  def show
    @check_box_question = CheckBoxQuestion.find(params[:id])

    respond_with(@check_box_question)
  end

  # GET /check_box_questions/new
  # GET /check_box_questions/new.xml
  def new
    @check_box_question = CheckBoxQuestion.new

    respond_with(@check_box_question)
  end

  # GET /check_box_questions/1/edit
  def edit
    @check_box_question = CheckBoxQuestion.find(params[:id])
  end

  # POST /check_box_questions
  # POST /check_box_questions.xml
  def create
    @check_box_question = CheckBoxQuestion.new(params[:check_box_question])

      if @check_box_question.save
        respond_with(@check_box_question)
      else
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @check_box_question.errors, :status => :unprocessable_entity }
        end
      end
  end

  # PUT /check_box_questions/1
  # PUT /check_box_questions/1.xml
  def update
    @old_check_box_question = CheckBoxQuestion.find(params[:id])
    @form = SiteForm.find(@old_check_box_question.site_form_id)
    
    @check_box_question = @old_check_box_question.clone
    @check_box_question.predefined_answers = @old_check_box_question.predefined_answers
    
    @old_check_box_question.site_form_id = nil
    @old_check_box_question.save

    respond_to do |format|
      if @check_box_question.update_attributes(params[:check_box_question])
        format.html { redirect_to([:management, @form], :notice => 'Question was successfully updated.') }
        format.xml  { head :ok }
        format.js { redirect_to([:management, @form], :notice => 'Question was successfully updated.') }
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
    @form = SiteForm.find(@check_box_question.site_form_id)
    
    @check_box_question.site_form_id = nil
    @check_box_question.save

    respond_to do |format|
      format.html { redirect_to([:management, @form]) }
      format.xml  { head :ok }
    end
  end
end

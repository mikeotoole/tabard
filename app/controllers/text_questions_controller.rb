class TextQuestionsController < ApplicationController
  respond_to :html, :xml, :js
  before_filter :authenticate, :except => [:index, :show]
  
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
    if !current_user.can_create(@text_question)
      render_insufficient_privileges
    else
      respond_with(@text_question)
    end
  end

  # GET /text_questions/1/edit
  def edit
    @text_question = TextQuestion.find(params[:id])
    if !current_user.can_update(@text_question)
      render_insufficient_privileges
    else
      respond_with(@text_question)
    end
  end

  # POST /text_questions
  # POST /text_questions.xml
  def create
    @text_question = TextQuestion.new(params[:text_question])
    if !current_user.can_create(@text_question)
      render_insufficient_privileges
    else
      if @text_question.save
        respond_with(@text_question)
      else
        grab_all_errors_from_model(@text_question)
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @text_question.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /text_questions/1
  # PUT /text_questions/1.xml
  def update
    @old_text_question = TextQuestion.find(params[:id])
    if !current_user.can_update(@old_text_question)
      render_insufficient_privileges
    else
      @form = SiteForm.find(@old_text_question.site_form_id)
      
      @text_question = @old_text_question.clone
      
      @old_text_question.site_form_id = nil
      @old_text_question.save
  
      respond_to do |format|
        if @text_question.update_attributes(params[:text_question])
          add_new_flash_message('Question was successfully updated.')
          format.html { redirect_to([:management, @form]) }
          format.xml  { head :ok }
          format.js { redirect_to([:management, @form]) }
        else
          grab_all_errors_from_model(@text_question)
          format.html { render :action => "edit" }
          format.xml  { render :xml => @text_question.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /text_questions/1
  # DELETE /text_questions/1.xml
  def destroy
    @text_question = TextQuestion.find(params[:id])
    if !current_user.can_delete(@text_question)
      render_insufficient_privileges
    else
      @form = SiteForm.find(@text_question.site_form_id)   
  
      @text_question.site_form_id = nil
      @text_question.save
  
      respond_to do |format|
        format.html { redirect_to([:management, @form]) }
        format.xml  { head :ok }
      end
    end
  end
end

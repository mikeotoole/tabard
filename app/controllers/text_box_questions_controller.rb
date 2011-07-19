class TextBoxQuestionsController < ApplicationController
  respond_to :html, :xml, :js
  before_filter :authenticate, :except => [:index, :show]
  
  # GET /text_box_questions
  # GET /text_box_questions.xml
  def index
    @text_box_questions = TextBoxQuestion.all

    respond_with(@text_box_questions)
  end

  # GET /text_box_questions/1
  # GET /text_box_questions/1.xml
  def show
    @text_box_question = TextBoxQuestion.find(params[:id])

    respond_with(@text_box_question)
  end

  # GET /text_box_questions/new
  # GET /text_box_questions/new.xml
  def new
    @text_box_question = TextBoxQuestion.new
    if !current_user.can_create(@text_box_question)
      render_insufficient_privileges
    else
      respond_with(@text_box_question)
    end
  end

  # GET /text_box_questions/1/edit
  def edit
    @text_box_question = TextBoxQuestion.find(params[:id])
    if !current_user.can_update(@text_box_question)
      render_insufficient_privileges
    end
  end

  # POST /text_box_questions
  # POST /text_box_questions.xml
  def create
    @text_box_question = TextBoxQuestion.new(params[:text_box_question])
    if !current_user.can_create(@text_box_question)
      render_insufficient_privileges
    else
      if @text_box_question.save
        respond_with(@text_box_question)
      else
        grab_all_errors_from_model(@text_box_question)
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @text_box_question.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /text_box_questions/1
  # PUT /text_box_questions/1.xml
  def update
    @old_text_box_question = TextBoxQuestion.find(params[:id])
    if !current_user.can_update(@text_box_question)
      render_insufficient_privileges
    else
      @form = SiteForm.find(@old_text_box_question.site_form_id)
      
      @text_box_question = @old_text_box_question.clone
      
      @old_text_box_question.site_form_id = nil
      @old_text_box_question.save
  
      respond_to do |format|
        if @text_box_question.update_attributes(params[:text_box_question])
          add_new_flash_message('Question was successfully updated.')
          format.html { redirect_to([:management, @form]) }
          format.xml  { head :ok }
          format.js { redirect_to([:management, @form]) }
        else
          grab_all_errors_from_model(@text_box_question)
          format.html { render :action => "edit" }
          format.xml  { render :xml => @text_box_question.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /text_box_questions/1
  # DELETE /text_box_questions/1.xml
  def destroy
    @text_box_question = TextBoxQuestion.find(params[:id])
    if !current_user.can_delete(@text_box_question)
      render_insufficient_privileges
    else
      @form = SiteForm.find(@text_box_question.site_form_id)
      
      @text_box_question.site_form_id = nil
      @text_box_question.save
  
      respond_to do |format|
        format.html { redirect_to([:management, @form]) }
        format.xml  { head :ok }
      end
    end
  end
end

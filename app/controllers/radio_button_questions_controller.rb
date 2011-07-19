class RadioButtonQuestionsController < ApplicationController
  respond_to :html, :xml, :js
  before_filter :authenticate, :except => [:index, :show]
  
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
    if !current_user.can_create(@radio_button_question)
      render_insufficient_privileges
    else
      respond_with(@radio_button_question)
    end
  end

  # GET /radio_button_questions/1/edit
  def edit
    @radio_button_question = RadioButtonQuestion.find(params[:id])
    if !current_user.can_update(@radio_button_question)
      render_insufficient_privileges
    end
  end

  # POST /radio_button_questions
  # POST /radio_button_questions.xml
  def create
    @radio_button_question = RadioButtonQuestion.new(params[:radio_button_question])
    if !current_user.can_create(@radio_button_question)
      render_insufficient_privileges
    else
      if @radio_button_question.save
        respond_with(@radio_button_question)
      else
        grab_all_errors_from_model(@radio_button_question)
        respond_to do |format|
         format.html { render :action => "new" }
         format.xml  { render :xml => @radio_button_question.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /radio_button_questions/1
  # PUT /radio_button_questions/1.xml
  def update
    @old_radio_button_question = RadioButtonQuestion.find(params[:id])
    if !current_user.can_update(@old_radio_button_question)
      render_insufficient_privileges
    else
      @form = SiteForm.find(@old_radio_button_question.site_form_id)  
      
      @radio_button_question = @old_radio_button_question.clone
      @radio_button_question.predefined_answers = @old_radio_button_question.predefined_answers   
      
      @old_radio_button_question.site_form_id = nil
      @old_radio_button_question.save
  
      respond_to do |format|
        if @radio_button_question.update_attributes(params[:radio_button_question])
          add_new_flash_message('Question was successfully updated.')
          format.html { redirect_to([:management, @form]) }
          format.xml  { head :ok }
          format.js { redirect_to([:management, @form]) }
        else
          grab_all_errors_from_model(@radio_button_question)
          format.html { render :action => "edit" }
          format.xml  { render :xml => @radio_button_question.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /radio_button_questions/1
  # DELETE /radio_button_questions/1.xml
  def destroy
    @radio_button_question = RadioButtonQuestion.find(params[:id])
    if !current_user.can_delete(@radio_button_question)
      render_insufficient_privileges
    else
      @form = SiteForm.find(@radio_button_question.site_form_id)
      
      @radio_button_question.site_form_id = nil
      @radio_button_question.save
  
      respond_to do |format|
        format.html { redirect_to([:management, @form]) }
        format.xml  { head :ok }
      end
    end
  end
end

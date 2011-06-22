class ComboBoxQuestionsController < ApplicationController
  respond_to :html, :xml, :js
  before_filter :authenticate, :except => [:index, :show]
  
  # GET /combo_box_questions
  # GET /combo_box_questions.xml
  def index
    @combo_box_questions = ComboBoxQuestion.all

    respond_with(@combo_box_questions)
  end

  # GET /combo_box_questions/1
  # GET /combo_box_questions/1.xml
  def show
    @combo_box_question = ComboBoxQuestion.find(params[:id])

    respond_with(@combo_box_question)
  end

  # GET /combo_box_questions/new
  # GET /combo_box_questions/new.xml
  def new
    @combo_box_question = ComboBoxQuestion.new
    if !current_user.can_create(@combo_box_question)
      render_insufficient_privileges
    else
      respond_with(@combo_box_question)
    end
  end

  # GET /combo_box_questions/1/edit
  def edit
    @combo_box_question = ComboBoxQuestion.find(params[:id])
    if !current_user.can_update(@combo_box_question)
      render_insufficient_privileges
    end
  end

  # POST /combo_box_questions
  # POST /combo_box_questions.xml
  def create
    @combo_box_question = ComboBoxQuestion.new(params[:combo_box_question])
    if !current_user.can_create(@combo_box_question)
      render_insufficient_privileges
    else
      if @combo_box_question.save
        respond_with(@combo_box_question)
      else
        respond_to do |format|
         format.html { render :action => "new" }
         format.xml  { render :xml => @combo_box_question.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /combo_box_questions/1
  # PUT /combo_box_questions/1.xml
  def update
    @old_combo_box_question = ComboBoxQuestion.find(params[:id])
    if !current_user.can_update(@old_combo_box_question)
      render_insufficient_privileges
    else
      @form = SiteForm.find(@old_combo_box_question.site_form_id)
      
      @combo_box_question = @old_combo_box_question.clone
      @combo_box_question.predefined_answers = @old_combo_box_question.predefined_answers 
      
      @old_combo_box_question.site_form_id = nil
      @old_combo_box_question.save
  
      respond_to do |format|
        if @combo_box_question.update_attributes(params[:combo_box_question])
          add_new_flash_message('Question was successfully updated.')
          format.html { redirect_to([:management, @form]) }
          format.xml  { head :ok }
          format.js { redirect_to([:management, @form]) }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @combo_box_question.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /combo_box_questions/1
  # DELETE /combo_box_questions/1.xml
  def destroy
    @combo_box_question = ComboBoxQuestion.find(params[:id])
    if !current_user.can_delete(@combo_box_question)
      render_insufficient_privileges
    else
      @form = SiteForm.find(@combo_box_question.site_form_id)
      
      @combo_box_question.site_form_id = nil
      @combo_box_question.save
  
      respond_to do |format|
        format.html { redirect_to([:management, @form]) }
        format.xml  { head :ok }
      end
    end
  end
end

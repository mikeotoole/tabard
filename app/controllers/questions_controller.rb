class QuestionsController < ApplicationController
  respond_to :html, :xml, :js

  # GET /questions/new
  # GET /questions/new.xml
  def new      
   @form = SiteForm.find_by_id(params[:site_form_id])  
       
   @question = case params[:q_type]
    when 'CheckBoxQuestion' then @check_box_question = CheckBoxQuestion.new(:site_form_id => @form.id)
      3.times { @check_box_question.predefined_answers.build }
      @check_box_question
    when 'ComboBoxQuestion' then @combo_box_question = ComboBoxQuestion.new(:site_form_id => @form.id)
      3.times { @combo_box_question.predefined_answers.build }
      @combo_box_question
    when 'RadioButtonQuestion' then @radio_button_question = RadioButtonQuestion.new(:site_form_id => @form.id)
      3.times { @radio_button_question.predefined_answers.build }
      @radio_button_question
    when 'TextBoxQuestion' then @text_box_question = TextBoxQuestion.new(:site_form_id => @form.id)
    when 'TextQuestion' then @text_question = TextQuestion.new(:site_form_id => @form.id) 
    else Question.new
   end

    respond_with(@question)
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.xml
  def create
    @question = Question.new(params[:question])

    respond_to do |format|
      if @question.save
        format.html { redirect_to(:back) }
        format.xml  { render :xml => @question, :status => :created, :location => @question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.xml
  def update
    @old_question = Question.find(params[:id])
    @form = SiteForm.find(@old_question.site_form_id)
    
    @question = @old_question.clone
    @question.save
    
    @old_question.site_form_id = nil
    @old_question.save

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to([:management, @form], :notice => 'Question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  def destroy
    @question = Question.find(params[:id])
    @form = SiteForm.find(@question.site_form_id)
    @question.site_form_id = nil
    @question.save

    respond_to do |format|
      format.html { redirect_to([:management, @form]) }
      format.xml  { head :ok }
    end
  end
end

=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This controller is for radio buttons.
=end
class RadioButtonQuestionsController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate, :except => [:index, :show]

  def index
    @radio_button_questions = RadioButtonQuestion.all
    respond_with(@radio_button_questions)
  end

  def show
    @radio_button_question = RadioButtonQuestion.find(params[:id])
    respond_with(@radio_button_question)
  end

  def new
    @radio_button_question = RadioButtonQuestion.new
    if !current_user.can_create(@radio_button_question)
      render_insufficient_privileges
    else
      respond_with(@radio_button_question)
    end
  end

  def edit
    @radio_button_question = RadioButtonQuestion.find(params[:id])
    if !current_user.can_update(@radio_button_question)
      render_insufficient_privileges
    end
    respond_with(@radio_button_question)
  end

  def create
    @radio_button_question = RadioButtonQuestion.new(params[:radio_button_question])
    if !current_user.can_create(@radio_button_question)
      render_insufficient_privileges
    else
      @radio_button_question.save
      grab_all_errors_from_model(@radio_button_question)
      respond_with(@radio_buttion_question)
    end
  end

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

=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This controller is for check box questions.
=end
class CheckBoxQuestionsController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate, :except => [:index, :show]
  
  def index
    @check_box_questions = CheckBoxQuestion.all
    respond_with(@check_box_questions)
  end

  def show
    @check_box_question = CheckBoxQuestion.find(params[:id])
    respond_with(@check_box_question)
  end

  def new
    @check_box_question = CheckBoxQuestion.new
    if !current_user.can_create(@check_box_question)
      render_insufficient_privileges
    else
      respond_with(@check_box_question)
    end
  end

  def edit
    @check_box_question = CheckBoxQuestion.find(params[:id])
    if !current_user.can_update(@check_box_question)
      render_insufficient_privileges
    else
      respond_with(@check_box_question)
    end
  end

  def create
    @check_box_question = CheckBoxQuestion.new(params[:check_box_question])
    if !current_user.can_create(@check_box_question)
      render_insufficient_privileges
    else
      @check_box_question.save
      grab_all_errors_from_model(@check_box_question)
      respond_with(@check_box_question)
    end
  end

  def update
    @old_check_box_question = CheckBoxQuestion.find(params[:id])
    if !current_user.can_update(@old_check_box_question)
      render_insufficient_privileges
    else
      @form = SiteForm.find(@old_check_box_question.site_form_id)
      
      @check_box_question = @old_check_box_question.clone
      @check_box_question.predefined_answers = @old_check_box_question.predefined_answers
      
      @old_check_box_question.site_form_id = nil
      @old_check_box_question.save
      if @check_box_question.update_attributes(params[:check_box_question])
        add_new_flash_message('Question was successfully updated.')
        redirect_to([:management,@form])
      else
        grab_all_errors_from_model(@check_box_question)
        respond_with(@check_box_question)
      end
    end
  end

  def destroy
    @check_box_question = CheckBoxQuestion.find(params[:id])
    if !current_user.can_delete(@check_box_question)
      render_insufficient_privileges
    else
      @form = SiteForm.find(@check_box_question.site_form_id)
      
      @check_box_question.site_form_id = nil
      @check_box_question.save
      grab_all_errors_from_model(@check_box_question)
      redirect_to([:management,@form])
    end
  end
end

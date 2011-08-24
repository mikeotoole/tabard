=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is for combo box questions.
=end
class ComboBoxQuestionsController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate, :except => [:index, :show]

  def index
    @combo_box_questions = ComboBoxQuestion.all
    respond_with(@combo_box_questions)
  end

  def show
    @combo_box_question = ComboBoxQuestion.find(params[:id])
    respond_with(@combo_box_question)
  end

  def new
    @combo_box_question = ComboBoxQuestion.new
    if !current_user.can_create(@combo_box_question)
      render_insufficient_privileges
    else
      respond_with(@combo_box_question)
    end
  end

  def edit
    @combo_box_question = ComboBoxQuestion.find(params[:id])
    if !current_user.can_update(@combo_box_question)
      render_insufficient_privileges
    end
  end

  def create
    @combo_box_question = ComboBoxQuestion.new(params[:combo_box_question])
    if !current_user.can_create(@combo_box_question)
      render_insufficient_privileges
    else
      @combo_box_question.save
      grab_all_errors_from_model(@combo_box_question)
      respond_with(@combo_box_question)
    end
  end

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

      if @combo_box_question.update_attributes(params[:combo_box_question])
        add_new_flash_message('Question was successfully updated.')
        redirect_to([:management,@form])
      else
        grab_all_errors_from_model(@combo_box_question)
        respond_with(@combo_box_question)
      end
    end
  end

  def destroy
    @combo_box_question = ComboBoxQuestion.find(params[:id])
    if !current_user.can_delete(@combo_box_question)
      render_insufficient_privileges
    else
      @form = SiteForm.find(@combo_box_question.site_form_id)

      @combo_box_question.site_form_id = nil
      @combo_box_question.save
      grab_all_errors_from_model(@combo_box_question)
      redirect_to([:management,@form])
    end
  end
end

###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for questions.
###
class Subdomains::QuestionsController < SubdomainsController
  respond_to :html

  ###
  # Before Filters
  ###
  before_filter :authenticate_user!
  before_filter :create_question, :only => [:new, :create]
  load_and_authorize_resource :except => [:index, :new, :create]
  authorize_resource :only => [:new, :create]
  skip_before_filter :limit_subdomain_access

  # GET /custom_forms/:custom_form_id/questions(.:format)
  def index
    form = CustomForm.find_by_id(params[:custom_form_id])
    @questions = form.questions if form
    authorize! :index, @questions
  end

  # GET /questions/:id(.:format)
  def show
    respond_with(@question)
  end

  # GET /custom_forms/:custom_form_id/questions/new(.:format)
  def new
    respond_with(@question)
  end

  # GET /questions/:id/edit(.:format)
  def edit
    respond_with(@question)
  end

  # POST /custom_forms/:custom_form_id/questions(.:format)
  def create
    @question.save
    respond_with(@question, :location => custom_form_url(@question.custom_form))
  end

  # PUT /questions/:id(.:format)
  def update # TODO Joe, How can we move this logic to the model? -MO
    if @question
      if !@question.answers.empty?
        new_question = @question.clone
        @question.custom_form_id = nil
        @question.save
        @question = new_question
      end
      add_new_flash_message('Question was successfully updated.') if @question.update_attributes(params[:question])
    end
    respond_with(@question, :location => custom_form_url(@question.custom_form))
  end

  # DELETE /questions/:id(.:format)
  def destroy # TODO Joe, How can we move this logic to the model? -MO
    if @question
      q_custom_form = @question.custom_form
      if @question.answers.empty?
        add_new_flash_message('Question was successfully deleted.') if @question.destroy
      else
        @question.custom_form_id = nil
        add_new_flash_message('Question was successfully deleted.') if @question.save
      end
    end
    respond_with(@question, :location => custom_form_url(q_custom_form))
  end

  ###
  # _before_filter_
  #
  # This before filter creates @question for the given question type and params if passed.
  ###
  def create_question
    custom_form = CustomForm.find_by_id(params[:custom_form_id])
    @question = Question.new_question(params[:question_type], params[:question])
    custom_form.questions << @question
  end
end
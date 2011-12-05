###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for handling submissions.
###
class Subdomains::SubmissionsController < SubdomainsController
  respond_to :html

  ###
  # Before Filters
  ###
  before_filter :block_unauthorized_user!
  before_filter :load_custom_form_from_id
  before_filter :load_submissions, :only => [:index]
  before_filter :create_submission, :only => [:new, :create]
  load_and_authorize_resource :except => [:index, :new, :create]
  authorize_resource :only => [:index, :new, :create]
  skip_before_filter :limit_subdomain_access

  # GET /custom_forms/:custom_form_id/submissions(.:format)
  def index
  end

  # GET /custom_forms/:custom_form_id/submissions/:id(.:format)
  def show
  end

  # GET /custom_forms/:custom_form_id/submissions/new(.:format)
  def new
    @submission.custom_form_questions.each do |question|
      @submission.answers.new :question_id => question.id
    end
  end

  # POST /custom_forms/:custom_form_id/submissions(.:format)
  def create
    add_new_flash_message 'Your submission was successful.', 'success' if @submission.save
    respond_with @submission, :location => root_url(:subdomain => current_community.subdomain)
  end

  # DELETE /submissions/:id(.:format)
  def destroy
    if @submission
      add_new_flash_message 'Submission was removed.', 'notice' if @submission.destroy
    end
    redirect_to custom_form_submissions_path @submission.custom_form
  end

  ###
  # _before_filter_
  #
  # This before filter loads the custom form from the id params.
  ###
  def load_custom_form_from_id
    @form = CustomForm.find_by_id params[:custom_form_id]
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to populate @submissions from the custom form.
  ###
  def load_submissions
    @submissions = @form.submissions if @form
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to create @submission from: submissions.new(params[:submission]) or submissions.new(), for the current custom form.
  ###
  def create_submission
    @submission = @form.submissions.new params[:submission] if @form
    @submission.user_profile = current_user.user_profile
  end
end

###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for answers.
###
class Subdomains::AnswersController < SubdomainsController
  respond_to :html

  ###
  # Before Filters
  ###
  before_filter :authenticate_user!
  before_filter :find_submission_by_id
  before_filter :load_answers, :only => [:index]
  before_filter :create_answer, :only => [:new, :create]
  load_and_authorize_resource :only => [:show]
  authorize_resource :only => [:index, :new, :create]
  skip_before_filter :limit_subdomain_access

  # GET /submissions/:submission_id/answers(.:format)
  def index
  end

  # GET /answers/:id(.:format)
  def show
    respond_with(@answer)
  end

  # GET /submissions/:submission_id/answers/new(.:format)
  def new
#    respond_with(@answer)
  end

  # POST /submissions/:submission_id/answers(.:format)
  def create
    @answer.save
    respond_with(@answer, :location => submission_url(@answer.submission))
  end

  ###
  # _before_filter_
  #
  # This before filter gets the submission from the id param.
  ###
  def find_submission_by_id
    @submission = Submission.find_by_id(params[:submission_id])
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to populate @answers from the current submission.
  ###
  def load_answers
    @answers = @submission.answers if @submission
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to create @answer from: answers.new(params[:answer]) or answers.new(), for the current submission.
  ###
  def create_answer
    @answer = @submission.answers.new(params[:answer]) if @submission
  end
end

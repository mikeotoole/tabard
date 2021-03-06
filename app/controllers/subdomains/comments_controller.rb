###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling comments within the scope of subdomains (communities).
###
class Subdomains::CommentsController < SubdomainsController
  layout nil

###
# Before Filters
###
  prepend_before_filter :block_unauthorized_user!
  before_filter :create_comment, only: [:new, :create]
  load_and_authorize_resource except: [:new, :create]
  authorize_resource only: [:new, :create]

###
# REST Actions
###
  # GET /comments/new
  def new
    render partial: 'form', locals: { comment: @comment }
  end

  # GET /comments/1/edit
  def edit
    render partial: 'form', locals: { comment: @comment }
  end

  # POST /comments
  def create
    if @comment.save
      set_last_posted_as(@comment.charater_posted? ? @comment.character : @comment.user_profile)
      render partial: 'comment', locals: { comment: @comment }
    else
      render text: '', layout: false
    end
  end

  # PUT /comments/1
  def update
    @comment.has_been_edited = true
    @comment.update_attributes(params[:comment])
    render partial: 'comment', locals: { comment: @comment }
  end

  # DELETE /comments/1
  def destroy
    render json: @comment.destroy ? true : false
  end

###
# Added Actions
###
  # POST /comments/:id/lock(.:format)
  def lock
    @comment.is_locked = true
    render json: @comment.save ? true : false
  end

  # POST /comments/:id/unlock(.:format)
  def unlock
    @comment.is_locked = false
    if @comment.save
      render partial: 'comment', locals: { comment: @comment }
    else
      render json: false
    end
  end

###
# Protected Methods
###
protected

###
# Callback Methods
###
  ###
  # _before_filter_
  #
  # This before filter attempts to populate @comment using current user.
  ###
  def create_comment
    if params[:comment]
      @comment = Comment.new(params[:comment])
    else
      @comment = Comment.new(commentable_type: params[:commentable_type], commentable_id: params[:commentable_id])
    end
    @comment.user_profile = current_user.user_profile
    @comment.form_target = params[:form_target] if params[:form_target]
    @comment.comment_target = params[:comment_target] if params[:comment_target]
  end
end

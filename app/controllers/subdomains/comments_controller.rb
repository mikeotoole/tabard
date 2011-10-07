###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling comments within the scope of subdomains (communities).
###
class Subdomains::CommentsController < ApplicationController
  layout nil
###
# Before Filters
###
  before_filter :authenticate_user!
  before_filter :create_comment, :only => [:new, :create]
  load_and_authorize_resource :except => [:new, :create]
  authorize_resource :only => [:new, :create]
  skip_before_filter :limit_subdomain_access

###
# REST Actions
###
  # GET /comments/new
  def new
    respond_with @comment
    # render :partial => 'form', :locals => { :comment => @comment }
  end

  # GET /comments/1/edit
  def edit
    render :partial => 'form', :locals => { :comment => @comment }
  end

  # POST /comments
  def create
    if @comment.save
      add_new_flash_message('Comment was successfully created.')
    else
      add_new_flash_message('Unable to create comment.', 'alert')
    end
    render :partial => 'comment', :locals => { :comment => @comment }
  end

  # PUT /comments/1
  def update
    @comment.has_been_edited = true
    if @comment.update_attributes(params[:comment])
      add_new_flash_message('Comment was successfully updated.')
    else
      add_new_flash_message('Unable to update comment.', 'alert')
    end
    render :partial => 'comment', :locals => { :comment => @comment }
  end

  # DELETE /comments/1
  def destroy
    @comment.has_been_deleted = true;
    if @comment.save
      add_new_flash_message('Comment was successfully deleted.')
      redirect_to url_for(@comment.original_comment_item), :action => :show
      return
    else
      add_new_flash_message('Comment was unable to be deleted.', 'alert')
      redirect_to url_for(@comment.original_comment_item), :action => :show
      return
    end
  end

###
# Added Actions
###
  # POST /comments/:id/lock(.:format)
  def lock
    @comment.has_been_locked = true
    if @comment.save
      add_new_flash_message("Comment was successfully locked.")
    else
      add_new_flash_message("Comment was not locked, internal rails error.", 'alert')
    end
  end

  # POST /comments/:id/unlock(.:format)
  def unlock
    @comment.has_been_locked = false
    if @comment.save
      add_new_flash_message("Comment was successfully unlocked.")
    else
      add_new_flash_message("Comment was not unlocked, internal rails error.", 'alert')
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
    @comment = Comment.new(params[:comment])
    
    @comment.user_profile = current_user.user_profile
    @comment.character_proxy = (character_active? ? current_character.character_proxy : nil)
    @comment.form_target = params[:form_target] if params[:form_target]
    @comment.comment_target = params[:comment_target] if params[:comment_target]
  end
end

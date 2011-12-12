###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for activity stream.
###
class ActivitiesController < ApplicationController
  respond_to :html, :js
  
  DEFAULT_MAX_ITEMS = 10
  
###
# Before Filters
###
  before_filter :block_unauthorized_user!, :except => [:index]

  ###
  # GET /activities
  # Possible params:
  # -> activity[user_profile_id]
  # -> activity[community_id]
  # -> updated_since
  # -> updated_before
  # -> max_items
  ###
  def index
    params[:max_items] = DEFAULT_MAX_ITEMS unless params[:max_items]
    #params[:updated_since] = 2.day.ago unless params[:updated_since]
    #params[:updated_before] = 3.months.ago unless params[:updated_before]
    
    if params[:updated_since] and params[:updated_before]
      @activities = Activity.ordered.where(params[:activity]).where('updated_at < :updated_since AND updated_at > :updated_before', params).first(params[:max_items].to_i)
      @comments = Comment.not_deleted.ordered.where(params[:activity]).where('updated_at < :updated_since AND updated_at > :updated_before',
                                                                              params).first(params[:max_items].to_i)
    elsif params[:updated_since]
      @activities = Activity.ordered.where(params[:activity]).where('updated_at > :updated_since', params).first(params[:max_items].to_i)
      @comments = Comment.not_deleted.ordered.where(params[:activity]).where('updated_at > :updated_since', params).first(params[:max_items].to_i)
    elsif params[:updated_before]
      @activities = Activity.ordered.where(params[:activity]).where('updated_at < :updated_before', params).first(params[:max_items].to_i)
      @comments = Comment.not_deleted.ordered.where(params[:activity]).where('updated_at < :updated_before', params).first(params[:max_items].to_i)
    else
      @activities = Activity.ordered.where(params[:activity]).first(params[:max_items].to_i)
      @comments = Comment.not_deleted.ordered.where(params[:activity]).first(params[:max_items].to_i)
    end
    
    @items = @activities + @comments
    @items.sort!{|item1, item2| item2.updated_at <=> item1.updated_at}
    @items = @items[0..params[:max_items]-1]
  end
end

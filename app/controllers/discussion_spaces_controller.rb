class DiscussionSpacesController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate
  # GET /discussion_spaces
  # GET /discussion_spaces.xml
  def index
      @discussion_spaces = DiscussionSpace.order("system DESC, name ASC")
      respond_with(@discussion_spaces)
  end

  # GET /discussion_spaces/1
  # GET /discussion_spaces/1.xml
  def show
    @discussion_space = DiscussionSpace.find(params[:id])
    if !current_user.can_show(@discussion_space)
      render :nothing => true, :status => :forbidden
    else
      respond_with(@discussion_space)
    end
  end
end

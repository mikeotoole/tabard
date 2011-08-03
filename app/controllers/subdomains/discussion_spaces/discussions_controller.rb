=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This controller is handling discussions within the scope of subdomains (communities).
=end
class DiscussionsController < SubdomainsController
  respond_to :html
  before_filter :get_discussion_space_from_id, :authenticate

  def new
    @discussion = @discussion_space.discussions.new
    @discussion.discussion_space = DiscussionSpace.find_by_id(params[:discussion_space])
    if !current_user.can_create(@discussion)
      render_insufficient_privileges
    else
      respond_with(@discussion)
    end
  end

  def create
    @discussion = Discussion.new(params[:discussion])
    @discussion.discussion_space = @discussion_space
    if !current_user.can_create(@discussion)
      render_insufficient_privileges
    else
      @discussion.user_profile = current_user.user_profile
      @discussion.character_proxy = (character_active? ? current_character.character_proxy : nil)
      if @discussion.save
        add_new_flash_message('Discussion was successfully created.')
      end
      grab_all_errors_from_model(@discussion)
      respond_with(@discussion)  
    end
  end
  
  def get_discussion_space_from_id
    @discussion_space = DiscussionSpace.find_by_id(params[:discussion_space_id])
  end
end

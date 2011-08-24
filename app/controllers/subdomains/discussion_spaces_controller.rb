=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is handling discussion spaces within the scope of subdomains (communities).
=end
class Subdomains::DiscussionSpacesController < SubdomainsController
  respond_to :html
  before_filter :authenticate, :get_option_hash

  def index
      @discussion_spaces = @community.discussion_spaces.only_real_ones.order("name ASC")
      @discussion_spaces.delete_if {|discussion_space| (!current_user.can_show(discussion_space))}
      #if !current_user.can_show("DiscussionSpace")
      #  render_insufficient_privileges
      #else
        respond_with(@discussion_spaces)
      #end
  end

  def show
    @discussion_space = @community.discussion_spaces.find(params[:id])
    if !current_user.can_show(@discussion_space)
      render_insufficient_privileges
    else
      # Site Announcement Space
      #if(@discussion_space.system and @discussion_space.announcement_space and @discussion_space.game == nil)
      #  render :partial => 'discussion_spaces/site_announcement_space'
      # Game Announcement Space
      #elsif(@discussion_space.system and @discussion_space.announcement_space and @discussion_space.game != nil)
      #  render :partial => 'discussion_spaces/game_announcement_space'
      # Registraion Appication Space
      #elsif(@discussion_space.system and @discussion_space.registration_application_space != nil)
      #  @registration_applications = RegistrationApplication.all_new
      #  @form = SiteForm.application_form
      #  render :partial => 'discussion_spaces/registration_application_space'
      #end
      respond_with(@discussion_space)
    end
  end

  def new
    @discussion_space = @community.discussion_spaces.new
    if !current_user.can_create(@discussion_space)
      render_insufficient_privileges
    else
      respond_with(@discussion_space)
    end
  end

  def edit
    @discussion_space = @community.discussion_spaces.find(params[:id])
    if !current_user.can_update(@discussion_space)
      render_insufficient_privileges
    end
    respond_with(@discussion_space)
  end

  def create
    @discussion_space = @community.discussion_spaces.new(params[:discussion_space])
    @discussion_space.system = false # TODO have the DB do this by default - JW
    @discussion_space.user_profile = current_user.user_profile
    if !current_user.can_create(@discussion_space)
      render_insufficient_privileges
    else
      if @discussion_space.save
        add_new_flash_message('Discussion space was successfully created.')
      end
      grab_all_errors_from_model(@discussion_space)
      respond_with(@discussion_space)
    end
  end

  def update
    @discussion_space = @community.discussion_spaces.find(params[:id])
    if !current_user.can_update(@discussion_space)
      render_insufficient_privileges
    else
      if @discussion_space.update_attributes(params[:discussion_space])
        add_new_flash_message('Discussion space was successfully updated.')
      end
      grab_all_errors_from_model(@discussion_space)
      respond_with(@discussion_space)
    end
  end

  def destroy
    @discussion_space = @community.discussion_spaces.find(params[:id])
    if !current_user.can_delete(@discussion_space)
      render_insufficient_privileges
    else
      if @discussion_space.destroy
        add_new_flash_message('Discussion space was successfully deleted.')
      end
      respond_with(@discussion_space)
    end
  end

  def get_option_hash
    @option_hash = { 'Games' => Game.where("is_active = ?", true).collect{ |game| [game.name, game.id] } }
  end
end

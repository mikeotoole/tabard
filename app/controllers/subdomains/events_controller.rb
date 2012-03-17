###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling events within the scope of subdomains (communities).
###
class Subdomains::EventsController < SubdomainsController
  respond_to :html
###
# Before Filters
###
  before_filter :authenticate_user!
  before_filter :ensure_current_user_is_member
  before_filter :load_event, :except => [:new, :create, :index]
  before_filter :create_event, :only => [:new, :create]
  authorize_resource :except => :index
  skip_before_filter :limit_subdomain_access

###
# REST Actions
###
  # GET /events
  def index
    @events = current_community.events
  end

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
  end

  # GET /events/1/edit
  def edit
    respond_with(@event)
  end

  # POST /events
  def create
    # TODO Mike, Need to be able to send one to many invites at creation.
    add_new_flash_message('Event was successfully created.') if @event.save
    respond_with(@event)
  end

  # PUT /events/1
  def update
    if @event.update_attributes(params[:event])
      add_new_flash_message('Event was successfully updated.')
    end
    respond_with(@event)
  end

  # DELETE /events/1
  def destroy
    add_new_flash_message('Event was successfully deleted.') if @event.destroy
    respond_with(@event)
  end
  
  # POST /events/:id/attend(.:format)
  def attend
    # TODO Mike, the admin needs to be able to add one to many attendees at anytime.
    participant = @event.participants.new()
    participant.user_profile = current_user.user_profile
    participant.character_proxy = (character_active? ? current_character.character_proxy : nil)
    if participant.save
      add_new_flash_message('Successfully marked event as attending.')
      redirect_to url_for(@event), :action => :show
      return
    else
      add_new_flash_message('Unable to marked event as attending.', 'alert')
      redirect_to url_for(@event), :action => :show
      return
    end
  end
  
  # POST /events/:id/invite(.:format)
  def invite
    if @event.invites.create(params[:invite])
      # TODO Mike, This should send a message to user. OR Create an observer.
      add_new_flash_message('Invite was successfully sent.')
      redirect_to url_for(@event), :action => :show
      return
    else
      add_new_flash_message('Invite was unable to be sent.', 'alert')
      redirect_to url_for(@event), :action => :show
      return
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
  # This before filter attempts to populate @event from the current_community.
  ###
  def load_event
    @event = current_community.events.find_by_id(params[:id]) if current_community
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to create @event from: events.new(params[:event]), for the current community.
  ###
  def create_event
    @event = current_community.events.new(params[:event]) if current_community
    @event.creator = current_user.user_profile
  end  
end

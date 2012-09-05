###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling events within the scope of subdomains (communities).
###
class Subdomains::EventsController < SubdomainsController
  include Rails.application.routes.url_helpers
  respond_to :html, :js
###
# Before Filters
###
  before_filter :authenticate_user!
  before_filter :ensure_current_user_is_member
  before_filter :load_event, except: [:new, :create, :index]
  before_filter :create_event, only: [:new, :create]
  before_filter :build_missing_invites, only: [:new, :create, :edit, :update]
  before_filter :rsvp_flash, only: [:show, :invites]
  authorize_resource except: [:index, :invites]
  skip_before_filter :limit_subdomain_access

###
# REST Actions
###
  # GET /events
  def index
    @events = Kaminari.paginate_array(current_community.events.includes(:supported_game).not_expired.delete_if{|event| cannot? :read, event}).page(params[:page])
  end

  # GET /events/past
  def past
    @events = Kaminari.paginate_array(current_community.events.includes(:supported_game).expired.delete_if{|event| cannot? :read, event}).page(params[:page])
  end

  # GET /events/:year/:month
  # GET /events/2012/03
  def month_index
    @month = params[:month].to_i
    @year = params[:year].to_i
    valid = (2000 <= @year and @year <= 3000)
    valid = (1 <= @month and @month <= 12) if valid

    if valid
      @date = DateTime.civil(@year, @month, 1).utc
      @events = current_community.events.intersects_with(@date, @date.end_of_month)
      @events_by_day = {}
      @events.each do |event|
        start = event.start_time < @date ? @date : event.start_time.to_datetime
        stop = event.end_time > @date.end_of_month ? @date.end_of_month : event.end_time.to_datetime
        start.upto(stop) do |date|
          @events_by_day[date.day] ||= []
          @events_by_day[date.day] << event
        end
      end
      render :month_index, layout: 'calendar'
    else
      flash[:alert] = 'Invalid date.'
      redirect_to month_events_url(year: Date.today.year, month: Date.today.month)
    end
  end

  # GET /events/:year/week/:week
  # GET /events/2012/week/44
  def week_index
    @year = params[:year].to_i
    @week = params[:week].to_i
    valid = (2000 <= @year and @year <= 3000)
    valid = (1 <= @week and @week <= 52) if valid

    if valid
      @date = DateTime.commercial(@year, @week, 1, 0, 0, 0, "#{Time.current.utc_offset / 3600}")
      @events = current_community.events.intersects_with(@date, @date.end_of_week)
      @events_by_cwday_by_hour = Hash[[1,2,3,4,5,6,7].map{|weekday| [weekday, Hash[(0..23).map{|hour| [hour, []] }]] }]
      @events.each do |event|
        event_start = event.start_time.to_datetime
        event_end = event.end_time.to_datetime
        @date.upto(@date.end_of_week) do |date|
          if event_start < date.end_of_day and event_end > date
            start = event_start < date ? date : event_start
            @events_by_cwday_by_hour[date.cwday][start.hour] << event
          end
        end
      end
      render :week_index, layout: 'calendar'
    else
      flash[:alert] = 'Invalid date.'
      redirect_to week_events_url year: Date.today.year, week: Date.today.cweek
    end
  end

  # GET /events/1
  def show
    @event.update_viewed(current_user.user_profile)
    @invites = @event.invites
    @comments= @event.comments.page params[:page]
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
    flash[:success] = 'Event was successfully created.' if @event.save
    respond_with(@event)
  end

  # PUT /events/1
  def update
    if @event.update_attributes(params[:event])
      flash[:success] = 'Event was successfully updated.'
    end
    respond_with(@event)
  end

  # DELETE /events/1
  def destroy
    flash[:notice] = 'Event has been removed.' if @event.destroy
    respond_with(@event)
  end

  # POST /events/:id/attend(.:format)
  def attend
    participant = @event.participants.new()
    participant.user_profile = current_user.user_profile
    participant.character_proxy = (character_active? ? current_character.character_proxy : nil)
    if participant.save
      flash[:success] = 'Successfully responded as attending.'
      redirect_to url_for(@event), action: :show
      return
    else
      flash[:alert] = 'Unable to respond to event.'
      redirect_to url_for(@event), action: :show
      return
    end
  end

  # GET /events/:id/invites(.:format)
  def invites
    authorize! :show, @event
    @invites = @event.invites
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
  # This before filter attempts to populate invites for @event
  ###
  def build_missing_invites
    current_community.member_profiles.each do |profile|
      old_thing = false
      @event.invites.each do |invite|
        if invite.user_profile_id == profile.id
          old_thing = true
          break
        end
      end
      @event.invites.build(user_profile_id: profile.id).mark_for_destruction unless @event.user_profiles.include?(profile) or old_thing
    end
    @event.invites.sort!{|a,b| a.user_profile_display_name <=> b.user_profile_display_name}
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

  # This adds a little flash notice to reminde the user to RSVP.
  def rsvp_flash
    default_url_options[:host] = ENV["RAILS_ENV"] == 'production' ? "#{current_community.subdomain}.tabard.co" : "#{current_community.subdomain}.lvh.me"
    invite = current_user.invites.find_by_event_id(@event.id)
    flash[:notice] = "You have not RSVP'd to this event yet. <a href='#{edit_invite_url(invite)}'>Respond now</a>" if invite != nil and invite.status == nil
  end
end

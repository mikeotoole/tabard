###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is used for searching.
###
class SearchController < ApplicationController
  respond_to :html, :js
  ###
  # Before Filters
  ###
  skip_before_filter :block_unauthorized_user!, only: [:index,:autocomplete]
  before_filter :basic_search_collection

###
# Actions
###
  # GET /search(.:format)
  def index
    unless params[:term].blank?
      @communities = Community.search params[:term]
      @users = UserProfile.active.search params[:term]
      # TODO: Joe, Add back CharacterProxy search -MO
#       @character_proxies = CharacterProxy.search params[:term]
#       @character_proxies_users = @character_proxies.map{|p| p.user_profile}.uniq
#       @users = @users - @character_proxies_users
#       @users_and_characters = Array.new
#       @character_proxies.group_by(&:user_profile).each do |user,proxies|
#         @users_and_characters << user
#         @users_and_characters << proxies
#       end
#       @users_and_characters = @users_and_characters.flatten
      @results = @communities + @users # + @users_and_characters
      @character_users = @characters.map{|c| c.user_profile}.uniq
      @users = @users - @character_users
      @users_and_characters = Array.new
      @characters.group_by(&:user_profile).each do |user_profile,character|
        @users_and_characters << user_profile
        @users_and_characters << character
      end
      @users_and_characters = @users_and_characters.flatten
      @results = @communities + @users + @users_and_characters
      @results = Kaminari.paginate_array(@results).page(params[:page]).per 10 if @results.any?
    end

    respond_to do |format|
      format.html {}
      format.js {
        html = render_to_string partial: 'results', locals: { results: @results }
        render json: { success: true, html: html }
      }
    end
  end

  # GET /search/autocomplete(.:format)
  def autocomplete
    @results = @communities + @users + @characters unless params[:term].blank?

    render json: @results.map{|r|
      case r.class.to_s
        when 'Community' then {
          label: "<strong>#{r.name}</strong>",
          value: r.name,
          url: root_url(subdomain: r.subdomain)
        }
        when 'UserProfile' then {
          label: "<strong>#{r.display_name}</strong>",
          value: r.display_name,
          url: user_profile_url(r),
          avatar: view_context.image_path(r.avatar_url(:icon))
        }
      when 'Character' then {
          label: "<strong>#{r.name}</strong> (#{r.user_profile.name})",
          value: r.name,
          url: user_profile_url(r.user_profile, anchor: 'characters'),
          avatar: view_context.image_path(r.avatar_url(:icon))
        }
      end
    }
  end

###
# Protected Methods
###
protected

  ###
  # _before_filter_
  # Uses given term to search models.
  ###
  def basic_search_collection
    if params[:term].blank?
      @results = []
    else
      @communities = Community.search params[:term]
      @users = UserProfile.active.search params[:term]
      # TODO: Joe, Add back CharacterProxy search -MO
      @character_proxies = [] #CharacterProxy.search params[:term]
    end
  end
end

class SearchController < ApplicationController
  respond_to :html, :js
  skip_before_filter :block_unauthorized_user!, only: [:index]
  before_filter :basic_search_collection

  def index
    unless params[:term].blank?
      @communities = Community.search params[:term]
      @users = UserProfile.active.search params[:term]
      @character_proxies = CharacterProxy.search params[:term]
      @character_proxies_users = @character_proxies.map{|p| p.user_profile}.uniq
      @users = @users - @character_proxies_users
      @users_and_characters = Array.new
      @character_proxies.group_by(&:user_profile).each do |user,proxies|
        @users_and_characters << user
        @users_and_characters << proxies
      end
      @users_and_characters = @users_and_characters.flatten
      @results = @communities + @users + @users_and_characters
    end

    respond_to do |format|
      format.html {
        @results = Kaminari.paginate_array(@results).page(params[:page]).per 10 if @results.any?
      }
      format.js {
      }
    end
  end

  def autocomplete
    unless params[:term].blank?
      @results = @communities + @users + @character_proxies
    end
    render json: @results.map{|r|
      logger.debug r.class
      case r.class.to_s
        when 'Community' then {
          label: r.name,
          value: r.name,
          url: root_url(subdomain: r.subdomain)
        }
        when 'UserProfile' then {
          label: r.display_name,
          value: r.display_name,
          url: user_profile_url(r),
          avatar: view_context.image_path(r.avatar_url(:icon))
        }
      when 'CharacterProxy' then {
          label: "#{r.name} (#{r.user_profile.name})",
          value: r.name,
          url: user_profile_url(r.user_profile, anchor: 'characters'),
          avatar: view_context.image_path(r.avatar_url(:icon))
        }
      end
    }
  end

  def basic_search_collection
    if params[:term].blank?
      @results = []
    else
      @communities = Community.search params[:term]
      @users = UserProfile.active.search params[:term]
      @character_proxies = CharacterProxy.search params[:term]
    end
  end
end
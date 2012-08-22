class SearchController < ApplicationController
  respond_to :html, :js
  skip_before_filter :block_unauthorized_user!, only: [:index]

  def index
    @communities = Community.search params[:term]
    @users = UserProfile.active.search params[:term]
    @results = @communities + @users

    respond_to do |format|
      format.html { Kaminari.paginate_array(@results).page params[:page] }
      format.js {
        render json: @results.map{|r|
          logger.debug r.class
          case r.class.to_s
            when 'Community' then {label: r.name, value: r.name, url: root_url(subdomain: r.subdomain)}
            when 'UserProfile' then {label: r.display_name, value: r.display_name, url: user_profile_url(r)}
          end
        }
      }
    end
  end
end
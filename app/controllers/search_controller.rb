class SearchController < ApplicationController
  skip_before_filter :block_unauthorized_user!, only: [:index]
  def index
    @users = UserProfile.active.search(params[:search])
    @communities = Community.search(params[:search])
    @results = @users + @communities
    Kaminari.paginate_array(@results).page(params[:page])
  end
end

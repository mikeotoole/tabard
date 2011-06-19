class SearchController < ApplicationController
  respond_to :html, :xml
  def index
    @search_term = params[:query]
    user_query = "%#{@search_term}%"
    @results = Array.new
    @results.concat @page_space_results = PageSpace.where{(name =~ user_query)}
    @results.concat @page_results = Page.where{(title =~ user_query) | (body =~ user_query)}
    @results.concat @discussion_space_results = DiscussionSpace.where{(name =~ user_query)}
    @results.concat @discussion_results = Discussion.where{(name =~ user_query) | (body =~ user_query)}
    @results.concat @comment_results = Comment.where{(body =~ user_query)}
    respond_with(@results)
  end

end

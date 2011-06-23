class SearchController < ApplicationController
  respond_to :html, :xml
  
  def index
    @search_term = params[:query]
    user_query = "%#{@search_term}%"
    
    @page_space_results = Array.new
    PageSpace.where{(name =~ user_query)}.each do |result|
      if true #TODO current_user.can_show(result)
        @page_space_results.push({
          :path => result,
          :name => result.name,
          :body => ''
        })
      end
    end
    
    @page_results = Array.new
    Page.where{(title =~ user_query) | (body =~ user_query)}.each do |result|
      if true #TODO current_user.can_show(result)
        @page_results.push({
          :path => [result.page_space,result],
          :name => result.title,
          :body => result.body
        })
      end
    end
    
    @discussion_space_results = Array.new
    #TODO - filter discussion spaces (like was done for the menu)
    DiscussionSpace.where{(name =~ user_query)}.each do |result|
      if true #TODO current_user.can_show(result)
        @discussion_space_results.push({
          :path => result,
          :name => result.name,
          :body => ''
        })
      end
    end
    
    @discussion_results = Array.new
    Discussion.where{(name =~ user_query) | (body =~ user_query)}.each do |result|
      if true #TODO current_user.can_show(result)
        @discussion_results.push({
          :path => result,
          :name => result.name,
          :body => result.body
        })
      end
    end
    
    @comment_results = Array.new
    Comment.where{(body =~ user_query)}.each do |result|
      if true #TODO current_user.can_show(result)
        @comment_results.push({
          :path => '#', #TODO discussion, discussion space, or whatever resource the comment is associated to
          :name => 'Comment by "' + (result.charater_posted? ? result.character.name : result.user_profile.name) + '"',
          :body => result.body
        })
      end
    end
    
    @results = Array.new
    @results.concat @page_space_results
    @results.concat @page_results
    @results.concat @discussion_space_results
    @results.concat @discussion_results
    @results.concat @comment_results
    
    respond_with(@results, @page_space_results, @page_results, @discussion_space_results, @discussion_results, @comment_results)
  end

end

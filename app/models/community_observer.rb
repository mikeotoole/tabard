class CommunityObserver < ActiveRecord::Observer
  def after_create(community)
    #probaly want to send an email
  end
end

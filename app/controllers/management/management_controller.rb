class Management::ManagementController < Communities::CommunitiesController
  before_filter :authenticate
  
  def index
    @registration_application_space = DiscussionSpace.registration_application_space
  end
  
end

class Subdomains::ManagementController < SubdomainsController
  before_filter :authenticate
  
  def index
    @registration_application_space = DiscussionSpace.registration_application_space # TODO Verfiy this is correct -JW
  end
  
end

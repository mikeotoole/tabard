=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is handling the management index within the scope of subdomains (communities).
=end
class Subdomains::ManagementController < SubdomainsController
  before_filter :authenticate

  def index
    @registration_application_space = DiscussionSpace.registration_application_space # TODO Verfiy this is correct -JW
  end

end

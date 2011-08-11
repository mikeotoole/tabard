=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class is a url constrain for routes.
=end
class Subdomain
  
=begin
  This determines if the request matches.
  [Returns] True if the request has a subdomain that is not "www", otherwise false.
=end
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != "www"
  end
end
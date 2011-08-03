=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class is a url constrain for routes.
=end
class Subdomain
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != "www"
  end
end
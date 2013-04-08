###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a url constrain for routes.
###
class Subdomain

###
# This determines if the request matches.
# [Returns] True if the request has a subdomain that is not "www", otherwise false.
###
  def self.matches?(request) # TODO: Joe - What does this do? -MO
    request.subdomain.present? && request.subdomain != "www" and request.subdomain != "secure" and request.subdomain != ""
  end
end

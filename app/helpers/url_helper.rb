###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This helper module is for improving urls for use with subdomains
###
module UrlHelper

  ###
  # This method monkey patches url_for to handle an optional subdomain hash argument.
  # [Args]
  #		* +options+ -> Hash of options.
  ###
  def url_for(options = nil)
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host] = with_subdomain(options.delete(:subdomain))
    end
    super
  end
  
###
# Protected Methods
###  
protected  
  
  ####
  # This method modifys a url_for option to add subdomain if it exists.
  # [Args]
  #		* +subdomain+ -> Subdomain to append.
  ###
  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, request.domain].join
  end
  
end

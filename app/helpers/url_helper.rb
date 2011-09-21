###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This helper module is for improving urls for use with subdomains
###
module UrlHelper  
  ###
  # This is a monkey patch to add subdomain option to the URL helper.
  # [Args]
  #   * +options+ -> Options for url_for
  ###
  def url_for(options = nil)
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host] = with_subdomain(options.delete(:subdomain))
      options[:port] = request.port_string.gsub(':','') unless request.port_string.empty?
    end
    super
  end

###
# Protected Methods
###
protected

  ###
  # This methods adds the subdomain to the domian url.
  # [Args]
  #   * +subdomain+ -> A string containing the subdomain to add.
  ###
  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, request.domain].join
  end
end

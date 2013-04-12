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
    if options.kind_of?(Hash)
      if defined?(current_community) and not current_community.blank? and current_community.respond_to?("subdomain")
        options[:host] = with_subdomain(current_community.subdomain)
      end
    end
    super
  end

  ###
  # This creates proper links for communities.
  # [Args]
  #   * +some_community+ -> Community to make links from.
  ###
  def actual_community_url(some_community)
    if some_community.respond_to?("subdomain")
      root_url(subdomain: some_community.subdomain)
    else
      root_url
    end
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
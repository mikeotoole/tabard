=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class is a community name validator.
=end
class CommunityNameValidator < ActiveModel::EachValidator  
  def validate_each(object, attribute, value)  
    if ::Community.where(:subdomain => ::Community.convert_to_subdomain(value)).exists?
      object.errors.add(attribute, :community_name, options.merge(:value => value))  
    end  
  end  
end
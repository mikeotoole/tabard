=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class is a community name validator.
=end
class CommunityNameValidator < ActiveModel::EachValidator
=begin
  This method validates a community, ensuring that the subdomains will not collide. If it finds a validation error, it will add an error message to the community name attribute.
  [Args]
    * +object+ -> The object (community) this is to be validated.
    * +attribute+ -> The attribute that is to be validated.
    * +value+ -> The value (name) that is to be validated.
  [Returns] True is the operation succeeded without errors, otherwise false.
=end
  def validate_each(object, attribute, value)
    if ::Community.where(:subdomain => ::Community.convert_to_subdomain(value)).exists?
      object.errors.add(attribute, :community_name, options.merge(:value => value))
    end
  end
end

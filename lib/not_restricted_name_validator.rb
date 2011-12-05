###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a validator used to ensure profanity is not present.
###
class NotRestrictedNameValidator < ActiveModel::EachValidator

###
# This method validates a value is not profanity.
# [Args]
#   * +object+ -> The object this is to be validated.
#   * +attribute+ -> The attribute that is to be validated.
#   * +value+ -> The value for attribute that is to be validated.
# [Returns] True if value is not restriced word, otherwise false.
###
  def validate_each(object, attribute, value)
    return unless value.present?
    if NameRestricter.restriced?(value.downcase, options)
      object.errors.add(attribute, :restriced, options.merge(:value => value))
    end
    if object and object.class.name == "Community"
      subdomain = Community.convert_to_subdomain(value)
      if NameRestricter.restriced?(subdomain, options)
        object.errors.add(attribute, :restriced, options.merge(:value => value))
      end
    end
  end
end
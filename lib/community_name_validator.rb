class CommunityNameValidator < ActiveModel::EachValidator  
  def validate_each(object, attribute, value)  
    if ::Community.where(:subdomain => ::Community.convert_to_subdomain(value)).exists?
      object.errors.add(attribute, :community_name, options.merge(:value => value))  
    end  
  end  
end
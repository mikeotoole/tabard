class CommunityNameValidator < ActiveModel::EachValidator  
  def validate_each(object, attribute, value)  
    if Community.find_by_subdomain(Community.convert_to_subdomain(value))
      object.errors[attribute] << (options[:message] || "has already been taken")  
    end  
  end  
end
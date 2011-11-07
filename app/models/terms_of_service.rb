###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a TermsOfService Document.
###
class TermsOfService < Document
  after_save :reset_user_acceptance

  # Sets a user's acceptance of the Terms of Service to false
  def reset_user_acceptance
    if self == TermsOfService.first
      User.update_all(:accepted_current_terms_of_service => false)
    end
  end
end
# == Schema Information
#
# Table name: documents
#
#  id         :integer         not null, primary key
#  type       :string(255)
#  body       :text
#  version    :string(255)
#  created_at :datetime
#  updated_at :datetime
#


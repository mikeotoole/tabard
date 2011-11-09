###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a PrivacyPolicy Document.
###
class PrivacyPolicy < Document
  after_save :reset_user_acceptance

  # Sets a user's acceptance of the Privacy Policy to false
  def reset_user_acceptance
    if self == PrivacyPolicy.first
      User.update_all(:accepted_current_privacy_policy => false)
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


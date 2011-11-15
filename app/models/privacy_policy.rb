###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a PrivacyPolicy Document.
###
class PrivacyPolicy < Document
###
# Public Methods
###
  ###
  # Gets the current Privacy Policy
  ###
  def self.current
    PrivacyPolicy.find(:first, :conditions => { :published => true })
  end

  ###
  # [Returns] true if this is the current Privacy Policy, false otherwise.
  ###
  def is_current?
    self.id == PrivacyPolicy.current.id
  end
end


# == Schema Information
#
# Table name: documents
#
#  id         :integer         not null, primary key
#  type       :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  version    :integer
#  published  :boolean         default(FALSE)
#


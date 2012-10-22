###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a PrivacyPolicy Document.
###
class PrivacyPolicy < Document
  validates_lengths_from_database
###
# Public Methods
###
  ###
  # Gets the current Privacy Policy
  ###
  def self.current
    PrivacyPolicy.where{is_published == true}.order(:version).first
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
#  id           :integer          not null, primary key
#  type         :string(255)
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  version      :integer
#  is_published :boolean          default(FALSE)
#


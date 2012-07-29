###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a TermsOfService Document.
###
class TermsOfService < Document
  validates_lengths_from_database
###
# Public Methods
###
  ###
  # Gets the current Terms Of Service
  ###
  def self.current
    TermsOfService.find(:first, conditions: { is_published: true })
  end

  ###
  # [Returns] true if this is the current Terms Of Service, false otherwise.
  ###
  def is_current?
    self.id == TermsOfService.current.id
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


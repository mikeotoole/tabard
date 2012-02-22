###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an Artwork Agreement Document.
###
class ArtworkAgreement < Document
###
# Public Methods
###
  # Gets the number of times this document has been accepted.
  def acceptance_count
    0 # TODO Mike, Add this.
  end

  ###
  # Gets the current Artwork Agreement
  ###
  def self.current
    ArtworkAgreement.find(:first, :conditions => { :is_published => true })
  end

  ###
  # [Returns] true if this is the current Artwork Agreement, false otherwise.
  ###
  def is_current?
    self.id == ArtworkAgreement.current.id
  end
end



# == Schema Information
#
# Table name: documents
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  body         :text
#  created_at   :datetime
#  updated_at   :datetime
#  version      :integer
#  is_published :boolean         default(FALSE)
#


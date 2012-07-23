###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an Artwork Agreement Document.
###
class ArtworkAgreement < Document
  validates_lengths_from_database
###
# Associations
###
  has_many :artwork_uploads, foreign_key: :document_id

###
# Public Methods
###
  # Gets the number of times this document has been accepted.
  def acceptance_count
    self.artwork_uploads.count
  end

  ###
  # Gets the current Artwork Agreement
  ###
  def self.current
    ArtworkAgreement.find(:first, conditions: { is_published: true })
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
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  version      :integer
#  is_published :boolean         default(FALSE)
#


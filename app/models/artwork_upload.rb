###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an uploaded artwork submission.
###
class ArtworkUpload < ActiveRecord::Base
  validates_lengths_from_database except: [:email, :artwork_image]
###
# Attribute accessor
###
  attr_accessor :accepted_current_artwork_agreement

###
# Attribute accessible
###
  attr_accessible :email, :attribution_name, :attribution_url,
                  :document_id, :accepted_current_artwork_agreement,
                  :artwork_image, :artwork_image_cache, :remote_artwork_image_url,
                  :artwork_description, :certify_owner_of_artwork, :owner_name,
                  :street, :city, :zipcode, :country, :state

###
# Associations
###
  belongs_to :document

###
# Validators
###
  validates :owner_name, presence: true
  validates :artwork_description, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :zipcode, presence: true
  validates :country, presence: true
  validates :attribution_name, if: :attribution_url?, presence: true
  validates :attribution_url, if: :attribution_name?, presence: true
  validates :artwork_image, presence: true
  validates :email,
      presence: true,
      length: { within: 5..128 },
      format: { with: %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i }
  validates :document, presence: true
  validates :accepted_current_artwork_agreement, acceptance: true
  validates :certify_owner_of_artwork, acceptance: {accept: true}
  validate :document_is_current
  validates :artwork_image,
      if: :artwork_image?,
      file_size: {
        maximum: 5.megabytes.to_i
      }

  delegate :body, to: :document, prefix: true
###
# Uploaders
###
  mount_uploader :artwork_image, ArtworkUploader

  # This gets the uploaded file name
  def upload_file_name
    read_attribute :artwork_image
  end

###
# Protected Methods
###
protected

###
# Validator Mathods
###
  # This validates that the document submitted is the current artwork agreement
  def document_is_current
    if self.document_id != ArtworkAgreement.current.id
      errors.add(:accepted_current_artwork_agreement, "agreement accepted was not current agreement")
      self.document = ArtworkAgreement.current
    end
  end
end


# == Schema Information
#
# Table name: artwork_uploads
#
#  id                       :integer         not null, primary key
#  owner_name               :string(255)
#  email                    :string(255)
#  street                   :string(255)
#  city                     :string(255)
#  zipcode                  :string(255)
#  state                    :string(255)
#  country                  :string(255)
#  attribution_name         :string(255)
#  attribution_url          :string(255)
#  artwork_image            :string(255)
#  artwork_description      :string(255)
#  certify_owner_of_artwork :boolean
#  document_id              :integer
#  created_at               :datetime        not null
#  updated_at               :datetime        not null
#


###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an uploaded artwork submission.
###
class ArtworkUpload < ActiveRecord::Base
###
# Attribute accessor
###
  attr_accessor :accepted_current_artwork_agreement

###
# Attribute accessible
###
  attr_accessible :email, :attribution_name, :attribution_url,
                  :artwork_image, :artwork_image_cache, :remote_artwork_image_url

###
# Associations
###
  belongs_to :document

###
# Validators
###
  validates :attribution_name, :if => :attribution_url?, :presence => true
  validates :attribution_url, :if => :attribution_name?, :presence => true
  validates :artwork_image, :presence => true
  validates :email,
      :length => { :within => 5..128 },
      :format => { :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i }
  validates :document, :presence => true
  validates :accepted_current_artwork_agreement,
      :acceptance => {:accept => true}

###
# Uploaders
###
  mount_uploader :artwork_image, ArtworkUploader
end

# == Schema Information
#
# Table name: artwork_uploads
#
#  id               :integer         not null, primary key
#  email            :string(255)
#  attribution_name :string(255)
#  attribution_url  :string(255)
#  artwork_image    :string(255)
#  document_id      :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#


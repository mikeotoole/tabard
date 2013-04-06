###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a theme.
###
class Theme < ActiveRecord::Base
  validates_lengths_from_database

###
# Attribute accessible
###
  attr_accessible :name, :css, :thumbnail

###
# Associations
###
  has_many :communities, inverse_of: :theme

###
# Validator
###
  validates :name,  presence: true, uniqueness: true
  validates :css,  presence: true
  validates :thumbnail,  presence: true
  validates :background_author,  presence: true, unless: Proc.new{|theme| theme.background_author_url.blank? }


  # This method returns the default theme.
  def self.default_theme
    Theme.find_or_create_by_name_and_css_and_thumbnail("Tabard", "default", "default.jpg")
  end

  ###
  # Only allow urls with http or https scheme.
  # This will prevent any XSS attacks through the url.
  ###
  def safe_background_author_url
    author_url = nil
    if self.background_author_url.present?
      uri = URI.parse("#{self.background_author_url}")
      author_url = self.background_author_url if %w(http https).include?(uri.scheme)
    end
    return author_url
  end
end

# == Schema Information
#
# Table name: themes
#
#  id                    :integer          not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  name                  :string(255)
#  css                   :string(255)
#  background_author     :string(255)
#  background_author_url :string(255)
#  thumbnail             :string(255)
#


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
  attr_accessible :name, :css, :thumbnail, :background_author, :background_author_url

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
    Theme.find_by_name("Guild.io")
  end
end










# == Schema Information
#
# Table name: themes
#
#  id                    :integer         not null, primary key
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  name                  :string(255)
#  css                   :string(255)
#  background_author     :string(255)
#  background_author_url :string(255)
#  thumbnail             :string(255)
#


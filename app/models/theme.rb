###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a theme.
###
class Theme < ActiveRecord::Base
  # This is a collection of strings that are valid for subject classes.
  VALID_THEMES = %w( Crumblin BlueDawn RedRum Commando )

###
# Attribute accessible
###
  attr_accessible :predefined_theme, :background_color, :background_image, :remove_background_image, :background_image_cache, :remote_background_image_url

###
# Associations
###
  belongs_to :community

###
# Validators
###
validates :predefined_theme, :presence => true, :inclusion => { :in => VALID_THEMES, :message => "\"%{value}\" is not a currently supported theme." }
validates :background_color, :format => { :with => /^[0-9a-fA-F]{6}$/, :message => "Only valid HEX colors are allowed." }
validates :background_color, :length => { :is => 6, :message => "Only valid HEX colors are allowed." }

###
# Uploaders
###
  mount_uploader :background_image, BackgroundImageUploader

  # This method returns the default theme.
  def self.default_theme
    "Crumblin"
  end
end




# == Schema Information
#
# Table name: themes
#
#  id               :integer         not null, primary key
#  community_id     :integer
#  background_image :string(255)
#  predefined_theme :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  background_color :string(255)
#


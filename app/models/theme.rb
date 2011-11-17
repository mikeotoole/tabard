###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a theme.
###
class Theme < ActiveRecord::Base
  # This is a collection of strings that are valid for subject classes.
  VALID_THEMES = %w( DEFAULT )

###
# Associations
###
  belongs_to :community

###
# Validators
###
validates :predefined_theme, :presence => true,
      :inclusion => { :in => VALID_THEMES, :message => "%{value} is not currently a supported theme" }

###
# Uploaders
###
  mount_uploader :background_image, BackgroundImageUploader

  # This method returns the default theme.
  def self.default_theme
    "DEFAULT"
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
#


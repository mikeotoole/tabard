###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a theme.
###
class Theme < ActiveRecord::Base
###
# Attribute accessible
###

###
# Associations
###
  has_many :communities, :inverse_of => :theme


  # This method returns the default theme.
  def self.default_theme
    Theme.find_by_name("Crumblin")
  end
end





# == Schema Information
#
# Table name: themes
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#  css        :string(255)
#  author     :string(255)
#  author_url :string(255)
#  thumbnail  :string(255)
#


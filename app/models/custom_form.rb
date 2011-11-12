###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a site form.
###
class CustomForm < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :name, :instructions, :thankyou, :published

###
# Associations
###
  has_many :questions, :dependent => :destroy
  accepts_nested_attributes_for :questions, :allow_destroy => true

  has_many :submissions, :dependent => :destroy
  belongs_to :community

###
# Validators
###
  validates :name, :presence => true
  validates :instructions, :presence => true
  validates :thankyou, :presence => true
  validates :community, :presence => true

###
# Delegates
###
  delegate :admin_profile_id, :to => :community, :allow_nil => true
  delegate :name, :to => :community, :prefix => true, :allow_nil => true

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method gets the name of the community that this form belongs to.
  # [Returns] A string that contains the display name of the community that this form belongs to, otherwise it contains the empty string.
  ###
  def community_name
    return self.community.name if self.community
    ""
  end
end

# == Schema Information
#
# Table name: custom_forms
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  instructions :text
#  thankyou     :string(255)
#  published    :boolean         default(FALSE)
#  community_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#


###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a folder.
###
class Folder < ActiveRecord::Base
  validates_lengths_from_database
###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name

###
# Associations
###
  belongs_to :user_profile
  has_many :messages, class_name: "MessageAssociation", dependent: :destroy

###
# Validators
###
  validates :name, presence: true
  validates :user_profile,  presence: true
end

# == Schema Information
#
# Table name: folders
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  user_profile_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#


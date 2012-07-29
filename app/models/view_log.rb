###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is used to track if a user has viewed an item.
###
class ViewLog < ActiveRecord::Base
  validates_lengths_from_database
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Associations
###
  belongs_to :user_profile
  belongs_to :view_loggable, polymorphic: true

###
# Validators
###
  validates :user_profile, presence: true
  validates :view_loggable, presence: true
end

# == Schema Information
#
# Table name: view_logs
#
#  id                 :integer          not null, primary key
#  user_profile_id    :integer
#  view_loggable_id   :integer
#  view_loggable_type :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  deleted_at         :datetime
#


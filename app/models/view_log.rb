###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is used to track if a user has viewed an item.
###
class ViewLog < ActiveRecord::Base
###
# Associations
###
  belongs_to :user_profile
  belongs_to :view_loggable, :polymorphic => true

###
# Validators
###
  validates :user_profile, :presence => true
  validates :view_loggable, :presence => true
end



# == Schema Information
#
# Table name: view_logs
#
#  id                 :integer         not null, primary key
#  user_profile_id    :integer
#  view_loggable_id   :integer
#  view_loggable_type :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  deleted_at         :datetime
#


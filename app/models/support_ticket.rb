###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is the support ticket class.
###
class SupportTicket < ActiveRecord::Base
  validates_lengths_from_database
  # Array of valid roles.
  STATUSES = %w[Pending\ Review In\ Progress Closed]

  # The default status
  DEFAULT_STATUS = "Pending Review"

###
# Attribute accessible
###
  attr_accessible :status, :body, :admin_user_id, :user_profile_id

###
# Associations
###
  belongs_to :admin_user, inverse_of: :support_tickets
  belongs_to :user_profile, inverse_of: :support_tickets
  has_many :support_comments, inverse_of: :support_ticket


###
# Delegates
###
  delegate :full_name, to: :user_profile, prefix: true
  delegate :id, to: :user_profile, prefix: true

  delegate :display_name, to: :admin_user, prefix: true
  delegate :email, to: :admin_user, prefix: true

###
# Validators
###
  validates :user_profile, presence: true
  validates :status,
            presence: true,
            inclusion: { in: STATUSES, message: "%{value} is not currently a supported status" }
  validates :body, presence: true
end

# == Schema Information
#
# Table name: support_tickets
#
#  id              :integer          not null, primary key
#  user_profile_id :integer
#  admin_user_id   :integer
#  status          :string(255)
#  body            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#


###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
#
###
class StripePlan < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :amount

###
# Callbacks
###
  before_create :create_plan_on_stripe

###
# Validators
###
  validates :amount, numericality: { :greater_than => 0 },
                       uniqueness: true

###
# Instance Methods
###

  def strip_id
    "pro-#{self.amount}"
  end

###
# Protected Methods
###
  protected

###
# Callback Methods
###

  def create_plan_on_stripe
    Stripe::Plan.create(
      :amount => self.amount,
      :interval => 'month',
      :name => self.strip_id,
      :currency => 'usd',
      :id => self.strip_id
    )
    # TODO Handle errors.
  end
end

# == Schema Information
#
# Table name: stripe_plans
#
#  id         :integer          not null, primary key
#  amount     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


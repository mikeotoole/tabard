###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is a single invoice item used for each paid service of an invoice.
###
class InvoiceItem < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Attribute accessible
###
  attr_accessible :quantity, :community, :community_id, :item, :item_type, :item_id

###
# Associations
###
  belongs_to :invoice, inverse_of: :invoice_items
  belongs_to :community
  belongs_to :item, polymorphic: true

###
# Callbacks
###
  before_save :set_dates

###
# Scopes
###
  scope :recurring, where{(is_recurring == true) & (is_prorated == false)}

###
# Validators
###
  validates :invoice, presence: true
  validates :community, presence: true
  validates :item, presence: true
  validates :quantity, presence: true
  validate :community_is_owned_by_user
  validate :only_one_community_plan_item_per_period


###
# Delegates
###
  delegate :period_start_date, to: :invoice
  delegate :period_end_date, to: :invoice
  delegate :price_per_month_in_cents, to: :item
  delegate :title, to: :item, prefix: true
  delegate :description, to: :item, prefix: true

###
# Instance Methods
###
  # Returns the total price for this item (price each * quantity) in cents.
  def total_price_in_cents
    self.price_per_month_in_cents * self.quantity
  end

  # Returns the total price for this item (price each * quantity) in dollars.
  def total_price_in_dollars
    self.total_price_in_cents / 100
  end

  # Returns true if the item is the default plan.
  def has_default_plan?
    self.item == CommunityPlan.default_plan
  end

###
# Protected Methods
###
protected

###
# Validator Mathods
###
  ###
  # _Validator_
  #
  # COMMENTED OUT
  ###
  def community_is_owned_by_user
#     self.errors.add(:base, "Broke!")
#     return false
  end

  ###
  # _Validator_
  #
  # Validates that plan dont overlap.
  ###
  def only_one_community_plan_item_per_period
    com_id = self.community_id
    start_d = self.start_date
    end_d = self.end_date
    self.errors.add(:base, "a plan already exists in that date range.") if self.item_type == "CommunityPlan" and InvoiceItem.where{(community_id == com_id) & (start_date > end_d) & (end_date < start_d)}.exists?
  end

###
# Callback Methods
###

  def set_dates
    self.start_date = self.invoice.period_end_date
    self.end_date = self.start_date + 30.days
  end
end

# == Schema Information
#
# Table name: invoice_items
#
#  id           :integer          not null, primary key
#  quantity     :integer
#  start_date   :datetime
#  end_date     :datetime
#  item_type    :string(255)
#  item_id      :integer
#  community_id :integer
#  is_recurring :boolean          default(TRUE)
#  is_prorated  :boolean          default(FALSE)
#  invoice_id   :integer
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


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
  before_validation :set_dates

###
# Scopes
###
  scope :recurring, where(is_recurring: true)
  scope :not_prorated, where(is_prorated: false)

###
# Validators
###
  validates :invoice, presence: true
  validates :community, presence: true
  validates :item, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1, only_integer: true}
  validates :quantity, numericality: { less_than_or_equal_to: 1, only_integer: true}, if: Proc.new{|ii| ii.item_type == "CommunityPlan"}
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :community_is_owned_by_user
  validate :is_recurring_and_is_prorated_not_both_true
  validate :only_one_community_plan_item_per_period
  validates_datetime :start_date, on_or_after: lambda {|ii| ii.period_start_date }, if: Proc.new{|ii| ii.is_prorated }
  validates_datetime :end_date, is_at: lambda {|ii| ii.period_end_date }, if: Proc.new{|ii| ii.is_prorated }
  validate :cant_be_edited_after_closed

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
    if self.is_prorated
      (self.price_per_month_in_cents / 30.0) * self.number_of_days * self.quantity
    else
      self.price_per_month_in_cents * self.quantity
    end
  end

  # Returns the total price for this item (price each * quantity) in dollars.
  def total_price_in_dollars
    self.total_price_in_cents / 100.0
  end

  # Title for this invoice item. If the item is prorated that will be denoted.
  def title
    self.is_prorated ? "Prorated - #{self.item_title}" : self.item_title
  end

  # Returns true if the item is the default plan.
  def has_default_plan?
    self.item == CommunityPlan.default_plan
  end

  def has_community_plan?
    self.item_type == "CommunityPlan"
  end

  def has_community_upgrade?
    self.item_type == "CommunityUserPackUpgrade"
  end

  def number_of_days
    distance_in_seconds = ((self.end_date - self.start_date).abs)
    distance_in_seconds / 1.day
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
  # This will inforce that an item can't be both recurring and prorated.
  # An item can be both not recurring and not prorated.
  ###
  def is_recurring_and_is_prorated_not_both_true
    self.errors.add(:base, "Prorated items can't be recurring.") if self.is_recurring and self.is_prorated
  end

  def cant_be_edited_after_closed
    if self.invoice.is_closed and self.invoice.is_closed_was
      self.errors.add(:base, "A closed invoice's invoice items can't be edited.")
    end
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
    some_id = self.id
    if self.item_type == "CommunityPlan" and InvoiceItem.where{(item_type == "CommunityPlan") & (community_id == com_id) & ((start_date > end_d) | (end_date < start_d) | ((start_date == start_d) & (end_date == end_d) & (id != some_id)))}.exists?
      self.errors.add(:base, "a plan already exists in that date range.")
    end
  end

###
# Callback Methods
###
  ###
  # _before_validation_
  #
  # This will set the item start and end dates based on the value of is_prorated.
  ###
  def set_dates
    if self.invoice.present? and not self.frozen?
      if self.is_prorated
        self.start_date = Time.now.beginning_of_day
        self.end_date = self.period_end_date
      else
        self.start_date = self.period_end_date
        self.end_date = self.start_date + 30.days
      end
    end
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


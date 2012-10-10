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
  belongs_to :community_user_pack_items, foreign_key: :item_id, class_name: "CommunityUserPackUpgrade"

###
# Callbacks
###
  before_validation :set_dates
  before_save :make_free_non_recurring

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
  validates_datetime :start_date, on_or_after: lambda {|ii| ii.period_start_date },
                                  on_or_after_message: 'must be after invoice start date',
                                  if: Proc.new{|ii| ii.is_prorated }
  validates_datetime :end_date, is_at: lambda {|ii| ii.period_end_date }, if: Proc.new{|ii| ii.is_prorated }
  validates_date :end_date, on_or_after: :start_date, on_or_after_message: 'must be after start date'
  validate :community_is_owned_by_user
  validate :is_recurring_and_is_prorated_not_both_true
  validate :only_one_community_plan_item_per_period
  validate :cant_be_edited_after_closed
  validate :item_is_avaliable, if: Proc.new{|ii| ii.item_type == "CommunityPlan"}
  validate :upgrade_is_compatable, if: Proc.new{|ii| ii.item_type != "CommunityPlan"}

###
# Delegates
###
  delegate :period_start_date, to: :invoice
  delegate :period_end_date, to: :invoice
  delegate :price_per_month_in_cents, to: :item
  delegate :title, to: :item, prefix: true
  delegate :description, to: :item, prefix: true
  delegate :user, to: :invoice

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

  # Returns true if the item is a CommunityPlan.
  def has_community_plan?
    self.item_type == "CommunityPlan"
  end

  # Returns true if the item is a CommunityUpgrade.
  def has_community_upgrade?
    (self.item_type == "CommunityUpgrade") or (self.item_type == "CommunityUserPackUpgrade")
  end

  # Determines if this invoice item is compatable with the plan.
  def is_compatable_with_plan?
    return true unless self.item_type != "CommunityPlan"
    plan_invoice_item = self.invoice.plan_invoice_item_for_community(self.community)
    plan = plan_invoice_item.item
    return plan.is_compatable_with_upgrade? self.item
  end

  # The number of days this invoice item is in effect for.
  def number_of_days
    distance_in_seconds = (self.end_date - self.start_date).abs
    (distance_in_seconds / 1.day).round
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
  # Validates that the community is owned by the invoice user.
  ###
  def community_is_owned_by_user
    self.errors.add(:base, "Community is not owned by user") unless self.user.owns_community?(self.community)
  end

  ###
  # _Validator_
  #
  # This will inforce that an item can't be both recurring and prorated.
  # An item can be both not recurring and not prorated.
  ###
  def is_recurring_and_is_prorated_not_both_true
    self.errors.add(:base, "prorated items can't be recurring.") if self.is_recurring and self.is_prorated
  end

  ###
  # _Validator_
  #
  # When the invoice is closed its items can't be updated.
  ###
  def cant_be_edited_after_closed
    if self.invoice.is_closed and self.invoice.is_closed_was
      self.errors.add(:base, "can't be edited when invoice is closed.")
    end
  end

  ###
  # _Validator_
  #
  # Validates that plans don't overlap.
  ###
  def only_one_community_plan_item_per_period
    if self.item_type == "CommunityPlan"
      com_id = self.community_id
      start_d = self.start_date
      end_d = self.end_date
      some_id = self.id
      iis = InvoiceItem.where{(id != some_id) &
                              (item_type == "CommunityPlan") &
                              (community_id == com_id) &
                              (((start_date < end_d) & (end_date > start_d)) |
                              ((start_date == start_d) | (end_date == end_d)))}
      self.errors.add(:base, "plan already exists in that date range.") unless iis.blank?
    end
  end

  ###
  # _Validator_
  #
  # Validates the community plan is avaliable.
  ###
  def item_is_avaliable
    self.errors.add(:item, "is not avaliable.") unless self.item.is_available
  end

  ###
  # _Validator_
  #
  # Validates the community upgrade is compatable with the plan.
  ###
  def upgrade_is_compatable
    self.errors.add(:item, "is not compatable with the invoice's plan.") unless self.is_compatable_with_plan?
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
    return true
  end

  ###
  # _before_save_
  #
  # This will make any free items non_recurring
  ###
  def make_free_non_recurring
    self.is_recurring = false if self.has_default_plan?
    return true
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


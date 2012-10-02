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
  attr_accessible :item, :quantity, :community_id, :item_type, :item_id

###
# Associations
###
  belongs_to :invoice, inverse_of: :invoice_items
  belongs_to :community
  belongs_to :item, polymorphic: true

###
# Callbacks
###
  before_validation :set_is_recurring
  before_save :copy_price
  before_save :set_dates

#   before_validation :set_price_each

###
# Validators
###
  #validates :invoice, presence: true
  #validates :price_each, presence: true
  #validates :quantity, presence: true
  #validates :discription, presence: true
  #validates :community, presence: true
  #validates_date :add_date, between: [:period_start_date, :period_end_date],
  #                          after_message: "Must be after invoice start date",
  #                          before_message: "Must be before invoice end date"
#   validate :community_is_owned_by_user
#   validates :item, presence: true

###
# Delegates
###
  delegate :period_start_date, to: :invoice
  delegate :period_end_date, to: :invoice
#
# ###
# # Protected Methods
# ###
# protected
#
# ###
# # Callback Methods
# ###

  def copy_price
    self.price_each = item.price_per_month_in_cents unless item.blank?
  end

  def set_dates
    self.start_date = self.invoice.period_end_date
    self.end_date = self.start_date + 30.days
  end

  ###
  # _before_validation_
  #
  #
  ###
  def set_is_recurring
    self.is_recurring = true
    self.is_prorated = false
  end
#
#   ###
#   # _before_validation_
#   #
#   #
#   ###
#   def set_price_each
#     self.quantity = 1
#     self.price_each = self.item.price_per_month_in_cents
#   end
end

# == Schema Information
#
# Table name: invoice_items
#
#  id           :integer          not null, primary key
#  price_each   :integer
#  quantity     :integer
#  add_date     :datetime
#  start_date   :datetime
#  end_date     :datetime
#  discription  :string(255)
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


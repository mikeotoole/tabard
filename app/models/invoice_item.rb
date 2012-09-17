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
  attr_accessible :item, :quantity

###
# Associations
###
  belongs_to :invoice
  belongs_to :commuinty
  belongs_to :item, polymorphic: true

###
# Validators
###
  validates :invoice, presence: true
  validates :price_each, presence: true
  validates :quantity, presence: true
  validates :discription, presence: true
  validates :commuinty, presence: true
  validates_date :add_date, between: [:period_start_date, :period_end_date],
                            after_message: "Must be after invoice start date",
                            before_message: "Must be before invoice end date"

###
# Delegates
###
  delegate :period_start_date, to: :invoice
  delegate :period_end_date, to: :invoice
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

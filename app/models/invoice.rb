###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is a single invoice used for paid services.
###
class Invoice < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Attribute accessible
###
  attr_accessible :invoice_items_attributes

###
# Associations
###
  belongs_to :user
  has_many :invoice_items, dependent: :destroy, inverse_of: :invoice

###
# Validators
###
  #validates :user, presence: true
  #validates_date :period_start_date, on_or_after: :today
  #validates_date :period_end_date, on_or_after: :period_start_date

  accepts_nested_attributes_for :invoice_items, allow_destroy: true

  def recurring_plan_invoice_item_for_community(community)
    com_id = community.id
    some_plan = self.invoice_items.where{(item_type == "CommunityPlan") & (is_recurring == true) & (community_id == com_id) & (is_prorated == false)}.limit(1).first
    if some_plan.blank?
      return self.invoice_items.new({item: CommunityPlan.default_plan, community: community}, without_protection: true) 
    else
      return some_plan
    end
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  stripe_invoice_id    :string(255)
#  period_start_date    :datetime
#  period_end_date      :datetime
#  paid_date            :datetime
#  stripe_customer_id   :string(255)
#  discount_percent_off :integer
#  discount_discription :string(255)
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#


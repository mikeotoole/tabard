# == Schema Information
#
# Table name: invoice_items
#
#  id                   :integer          not null, primary key
#  quantity             :integer
#  start_date           :datetime
#  end_date             :datetime
#  item_type            :string(255)
#  item_id              :integer
#  community_id         :integer
#  is_recurring         :boolean          default(TRUE)
#  is_prorated          :boolean          default(FALSE)
#  invoice_id           :integer
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  was_charge_exempt    :boolean          default(FALSE)
#  charge_exempt_label  :string(255)
#  charge_exempt_reason :text
#

require 'spec_helper'

describe InvoiceItem do
  let(:invoice_item) { create(:invoice_item) }
  let(:invoice) { invoice_item.invoice }
  let(:basic_invoice_item) { build(:basic_invoice_item)}
  let(:upgrade_invoice_item) { create(:upgrade_invoice_item) }

  it "should create a new instance given valid attributes" do
    invoice_item.should be_valid
  end

  it "should only have one plan per period" do
    pending
  end

  it "should not be able to be edited after it is closed" do
    invoice.mark_paid_and_close
    invoice_item.is_recurring.should be_true
    invoice_item.is_recurring = false
    invoice_item.save.should be_false
    invoice_item.is_recurring.should be_true
  end

  it "should not be able to be edited when it is prorated" do
    pending
  end

###
# Attributes
###
  describe "invoice" do
    it "should be required" do
      basic_invoice_item.save.should be_false
      basic_invoice_item.invoice = FactoryGirl.build(:invoice, user_id: DefaultObjects.community_admin_with_stripe_out_state.id)
      basic_invoice_item.save.should be_true
    end
  end

  describe "community" do
    it "should be required" do
      invoice_item.community = nil
      invoice_item.save.should be_false
    end

    it "should be owned by the user" do
      invoice_item.community = create(:community)
      invoice_item.save.should be_false
    end
  end

  describe "is_prorated" do
    it "should not be true if is recurring" do
      invoice_item.is_recurring.should be_true
      invoice_item.is_prorated = true
      invoice_item.save.should be_false
    end
  end

  describe "item" do
    it "should be required" do
      invoice_item.item = nil
      invoice_item.save.should be_false
    end
  end

  describe "quantity" do
    it "should be required" do
      invoice_item.quantity = nil
      invoice_item.save.should be_false
    end
    it "should be editable for upgrades" do
      upgrade_invoice_item.quantity = 2
      upgrade_invoice_item.save.should be_true
      upgrade_invoice_item.quantity.should eq 2
    end
    it "should be greater than or equal to 0" do
      upgrade_invoice_item.quantity = -1
      upgrade_invoice_item.save.should be_false
    end
    it "should be only integer" do
      upgrade_invoice_item.quantity = "fuck"
      upgrade_invoice_item.save.should be_true
      upgrade_invoice_item.quantity.should eq 1
    end
    it "should only be 1 if the item is a community plan" do
      invoice_item.quantity = 2
      invoice_item.save.should be_false
    end
  end

  describe "start_date" do
    it "should be required" do
      pending
    end
  end

  describe "end_date" do
    it "should be required" do
      pending
    end
    it "should be at the end date if it is prorated" do
      pending
    end
    it "shoud be after start date" do
      pending
    end
  end

###
# Callbacks
###
  it "should be set as recurring" do
    pending
  end

  it "should set dates" do
    pending
  end

  it "should set destruction when quantity is zero or incompatable" do
    pending
  end

  it "should make free non recurring" do
    pending
  end

###
# Methods
###
  describe "total price in cents" do
    it "should return price multiplied by quantity when not prorated" do
      pending
    end
    it "should return price multiplied by quantity divided by the fraction of the 30 days when prorated" do
      pending
    end
  end

  describe "total price in dollars" do
    it "it should be the correct converion from price in cents" do
      pending
    end
  end

  describe "title" do
    it "should return the title from the item when not prorated" do
      pending
    end
    it "should prepend Prorated if prorated" do
      pending
    end
  end

  describe "has default plan" do
    it "should return true if the item is the default plan" do
      pending
    end
    it "should return false if the item is not the default plan" do
      pending
    end
  end

  describe "has community plan" do
    it "should return true if the item is a community plan" do
      pending
    end
    it "should return false if the item is not a community plan" do
      pending
    end
  end

  describe "has community upgrade" do
    it "should return true if the item is a community upgrade" do
      pending
    end
    it "should return false if the item is not a community upgrade" do
      pending
    end
  end

  describe "is compatable with plan" do
    it "should return true if the item is compatable with the community plan" do
      pending
    end
    it "should return false if the item is not compatable with the community plan" do
      pending
    end
  end

  describe "number of day" do
    it "should return the elapsed time" do
      pending
    end
  end

  describe "number  of users each" do
    it "should return the number of users that the item gives" do
      pending
    end
  end
end
